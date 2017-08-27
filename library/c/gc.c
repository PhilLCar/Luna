#include <stdio.h>
#include <errno.h>
#include <err.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>
#include "types.h"

#ifdef __linux__
#define stack_base  _stack_base
#define mem_size    _mem_size
#define mem_max     _mem_max
#define trf_mask    _trf_mask
#define gc          _gc
#endif

quad *stack_base;
quad mem_size;
quad mem_max;
quad trf_mask = 0x4000000000000000;

static quad *copy;
static quad heartbreaker = 0x8000000000000000;

static quad copydata(quad);
static void copyll(quad*, quad*);

quad copydata(quad data)
{
  int type = data & 7;
  quad *point = P(data >> 3);
  quad *base, *p;
  int i, size, max, min;

  //printf("%llx:%d\n", Q(point), type);
  if (trf_mask & data) return data;
  else if (type == ADDRESS || type == SPECIAL) return data;
  else if (type != DOUBLE && Q(point) != NIL && *point & heartbreaker) return (*point << 3) | type;
  
  switch(type) {

  case STRING:
    *copy = *(point++);
    base = copy++;
    max = *base;
    for (i = 0; i <= max; i++)
      C(copy)[i] = C(point)[i];
    copy = P((Q(copy) + max + 8) & Q(-8));
    return (Q(base) << 3) | STRING;

  case TABLE:
    *copy = *point;
    *(point++) = heartbreaker | Q(copy);
    base = copy;
    copy += 3;
    if (*base == -VOID) {
      base[1] = point[0];
      base[2] = point[1];
      return (Q(base) << 3) | TABLE;
    }
    // Copy linked list sequence
    copyll(point++, base + 1);
    // Copy array sequence
    if (*point != NIL) {
      point = P(*point);
      size = (*point >> 3) + 2;
      p = copy;
      copy = copy + size;
      max = -1;
      for (i = 0; i < size; i++) {
        p[i] = copydata(point[i]);
	point[i] = heartbreaker | Q(p + i);
	if (copy[i] != NIL) {
	  if (min < 0) min = i;
	  max = i;
	}
      }
      //if ((max - min) * 2 < cap) {
      // RESIZE !!!
      //} else {
      base[2] = Q(p);
      //}
    } else base[2] = NIL;
    return (Q(base) << 3) | TABLE;

  case OBJECT:
    if (Q(point) == NIL) return (NIL << 3) | OBJECT;
    switch (*point) {
      quad ret;
    case O_CLO:
      ret = (Q(copy) << 3) | OBJECT;
      p = copy;
      while (Q(point) != NIL) {
	if (*point & heartbreaker) return (*point << 3) | OBJECT;
	base = copy;
	copy += 4;
	*p = Q(base);
	base[0] = point[0]; //tag
	base[1] = copydata(point[1]); //key
	base[2] = copydata(point[2]); //value
	point[0] = heartbreaker | Q(base);
	point[2] = heartbreaker | Q(base + 2);
	p = base + 3;
	point += 3;
	point = P(*point);
      }
      *p = NIL;
      return ret;
    case O_FILE:
      base = copy;
      copy += 2;
      base[0] = point[0];
      base[1] = point[1];
      point[0] = heartbreaker | Q(base);
      return (Q(base) << 3) | OBJECT;
    }
    break;
    
  case STACK:
    ////printmem(point, 20);
    // Seek end
    for (size = 0; point[-size] != VOID; size++);
    base = (copy + size);
    copy = base + 1;
    for (i = 0; i <= size; i++) base[-i] = copydata(point[-i]);
    point[0] = heartbreaker | Q(base);
    return (Q(base) << 3) | STACK;
    
  case DOUBLE:
    *copy = *point;
    return (Q(copy++) << 3) | DOUBLE;
    
  case FUNCTION:
    *copy = *point;
    *(point++) = heartbreaker | Q(copy);
    base = copy;
    copy += 2;
    // Copy closure environment linked list
    base[1] = copydata((Q(*point) << 3) | OBJECT) >> 3;
    return (Q(base) << 3) | FUNCTION;
  }
  return NIL;
}

quad maketransfer(quad data)
{
  quad val = *P(trf_mask ^ data);
  if (!(val & heartbreaker)) return data;
  return (val ^ heartbreaker) | trf_mask;
}

void copyll(quad *point, quad *last)
{
  quad *base;
  while (*point != NIL) {
    point = P(*point);
    base = copy;
    copy += 3;
    base[0] = copydata(point[0]);
    base[1] = copydata(point[1]);
    *last = Q(base);
    last = base + 2;
    point[1] = heartbreaker | Q(base + 1);
    point += 2;
  }
  *last = NIL;
}

void printmem(quad *start, int lines)
{
  int i, offset = 0x60;
  printf
    ("---------------------------------------------------------------------------------------------\n");
  for (i = offset + lines / 4 - 1; i >= offset; i--)
    printf("%04x:%016llx\t%04x:%016llx\t%04x:%016llx\t%04x:%016llx\n",
	   8 * i, *(start + i),
	   8 * (i + lines / 4), *(start + i + lines / 4),
	   8 * (i + lines / 2), *(start + i + lines / 2),
	   8 * (i + lines / 4 * 3), *(start + i + lines / 4 * 3));
  printf
    ("---------------------------------------------------------------------------------------------\n");
}

vals gc(quad *stack_ptr, quad *mem_ptr, quad *mem_base)
{
  vals new;
  quad *i;
  
  copy = (quad*)mmap(NULL,
		     (size_t)mem_size,
		     PROT_READ | PROT_WRITE | PROT_EXEC,
		     MAP_PRIVATE | MAP_ANON, -1, 0);
  new.mem_base = copy;
  
  if (copy == MAP_FAILED) {
    fprintf(stderr, "Memory allocation failed (Process aborted)\n");
    exit(1);
  }
  
  // Globals
  copydata((Q(mem_base) << 3) | TABLE);

  printf("**********************************************************************\n");
  printmem(mem_base, 74);
  
  // Stack
  for (i = stack_base - 1; i >= stack_ptr; i--) {
    printf("%016llX\t:\t%016llX\n", Q(i), *i);
    if (*i == FRAH) {
      i[-1] = copydata(i[-1]);
      i -= 4;
      continue;
    } // for ahead
    *i = copydata(*i);
  }
  printf("*****************************************************\n");
  for (i = stack_base - 1; i >= stack_ptr; i--) {
    if (*i == FRAH) { i -= 4; continue; } // for ahead
    if (*i & trf_mask)
      *i = maketransfer(*i);
    printf("%016llX\t:\t%016llX\n", Q(i), *i);
  }

  munmap(mem_ptr, mem_size);

  new.mem_ptr  = copy;

  /*/ Resizing -- if compacted data is over the max, the GC would perpetually be called
  if ((copy - new.mem_base) > (mem_size / 4 * 3)) {
    copy = mmap(NULL,
		(size_t)(mem_size << 1),
		PROT_READ | PROT_WRITE | PROT_EXEC,
		MAP_PRIVATE | MAP_ANON, -1, 0);
    if (copy == MAP_FAILED) {
      fprintf(stderr, "Memory reallocation failed (Process aborted)\n");
      exit(1);
    }
    memcpy(copy, new.mem_ptr, mem_size);
    munmap(new.mem_ptr, mem_size);
    mem_size <<= 1;
    new.mem_ptr = copy;
  } else if ((copy - new.mem_base) > (mem_size / 4)) {
    copy = mmap(NULL,
		(size_t)(mem_size >> 1),
		PROT_READ | PROT_WRITE | PROT_EXEC,
		MAP_PRIVATE | MAP_ANON, -1, 0);
    if (copy == MAP_FAILED) {
      fprintf(stderr, "Memory reallocation failed (Process aborted)\n");
      exit(1);
    }
    memcpy(copy, new.mem_ptr, mem_size / 4);
    munmap(new.mem_ptr, mem_size);
    mem_size >>= 1;
    new.mem_ptr = copy;
    }*/

  printmem(new.mem_base, 64);
  
  mem_max = Q(new.mem_base) + (mem_size / 4 * 3);
    
  return new;
}
