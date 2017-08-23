#include <stdio.h>
#include <errno.h>
#include <err.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>

typedef long long quad;
typedef struct Vals {
  quad *mem_base;
  quad *mem_ptr;
} vals;

#ifdef __linux__
#define stack_base  _stack_base
#define mem_size    _mem_size
#define mem_max     _mem_max
#define trf_mask    _trf_mask
#define gc          _gc
#endif

#define P(x) ((quad*)(x))
#define C(x) ((char*)(x))
#define Q(x) ((quad)(x))
#define B(x) ((char)(x))

#define ADDRESS  0
#define SPECIAL  1
// Special values
   #define FALSE 1
   #define TRUE  9
   #define NIL   17
   #define VOID  33
   #define UNKN  65
   #define FRAH  129
#define STRING   2
#define TABLE    3
#define OBJECT   4
// Object values
   #define CLO   0
#define STACK    5
#define DOUBLE   6
#define FUNCTION 7

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
    //fprintf(stderr, "%p\n", point);
    *copy = *(point++);
    //*(point++) = heartbreaker | Q(copy);
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
    //fprintf(stderr, "Y:%lld\n", *base);
    if (*base == VOID) {
      //fprintf(stderr, "DEFLECTED\n");
      base[1] = point[0];
      base[2] = point[1];
      return (Q(base) << 3) | TABLE;
    }
    // Copy linked list sequence
    //fprintf(stderr, "%lld\n", base[2]);
    copyll(point++, base + 1);
    //printmem(base, 20);
    //printmem(point - 2, 20);
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
    case CLO:
      ret = (Q(copy) << 3) | OBJECT;
      p = copy;
      while (Q(point) != NIL) {
	//printf("loop: %p\n", point);
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
    }
    break;
    
  case STACK:
    ////printmem(point, 20);
    // Seek end
    for (size = 0; point[-size] != VOID; size++);
    //fprintf(stderr, "copy old : %p\n", copy);
    base = (copy + size);
    //fprintf(stderr, "base old : %p\n", base);
    copy = base + 1;
    //fprintf(stderr, "copy new : %p\n", copy);
    //printf("%d\n", size);
    for (i = 0; i <= size; i++) {
      //fprintf(stderr, "point : %016llx\n", point[-i]);
      //fprintf(stderr, "base  : %016llx\n", base[-i]);
      base[-i] = copydata(point[-i]);
    }
    //printf("%016llx\n", copydata(point[0]));
    ////printmem(base, 20);
    point[0] = heartbreaker | Q(base);
    return (Q(base) << 3) | STACK;
    
  case DOUBLE:
    *copy = *point;
    //printf("P: %016llx\n", *point);
    //printf("P: %016llx\n", *copy);
    //*point = heartbreaker | Q(copy);
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
  //printf("yo:%llx\n", trf_mask);
  quad val = *P(trf_mask ^ data);
  // During debug only, can remove for better performance if safe
  if (!(val & heartbreaker)) return data;
  return (val ^ heartbreaker) | trf_mask;
}

void copyll(quad *point, quad *last)
{
  quad *base;
  while (*point != NIL) {
    //printf("p:%llx\n", *point);
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
  int i, offset = 0;
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

// Peut-être appeler le GC dans les boucles aussi!
vals gc(quad *stack_ptr, quad *mem_ptr, quad *mem_base)
{
  vals new;
  quad *i;
  //printf("gc!\n");
  /*
    printf("-----------------------------------------\n");
    for (i = stack_base - 1; i >= stack_ptr; i--) {
    printf("%p:\t0x%016llX\n", i, *i);
    }
    printf("-----------------------------------------\n");
  */

  copy = (quad*)mmap(NULL,
		     (size_t)mem_size,
		     PROT_READ | PROT_WRITE | PROT_EXEC,
		     MAP_PRIVATE | MAP_ANON, -1, 0);
  new.mem_base = copy;

  //printf("STEP: %p\n", copy);
  //printmem(mem_base, 64);
  
  if (copy == MAP_FAILED) {
    fprintf(stderr, "Memory allocation failed (Process aborted)\n");
    exit(1);
  }
  
  // Globals
  copydata((Q(mem_base) << 3) | TABLE);
  //printmem(new.mem_base, 48);
  //printf("Étape 2\n");
  //for (i = stack_base - 1; i >= stack_ptr; i--)
  //fprintf(stderr, "%p:\t0x%016llX\n", i, *i);
  // Stack
  for (i = stack_base - 1; i >= stack_ptr; i--) {
    //fprintf(stderr, "%p:\t0x%016llX\n", i, *i);
    if (*i == FRAH) {
      //printf("B:%llx\n", i[1]);
      //printf("A:%llx\n", copydata(i[1]));
      i[-1] = copydata(i[-1]);
      i -= 4;
      continue;
    } // for ahead
    *i = copydata(*i);
    //printmem(new.mem_base, 64);
    //printf("%p:\t0x%016llX\n", i, *i);
  }
  //getchar();
  for (i = stack_base - 1; i >= stack_ptr; i--) {
    if (*i == FRAH) { i -= 4; continue; } // for ahead
    if (*i & trf_mask)
      *i = maketransfer(*i);
    //fprintf(stderr, "%p:\t0x%016llX\n", i, *i);
  }
  //printf("Étape 3\n");
  //printf("Étape 4\n");

  munmap(mem_ptr, mem_size);
  //printf("Étape 5\n");

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
  
  mem_max = Q(new.mem_base) + (mem_size / 4 * 3);
  //printmem(new.mem_base, 48);
  //for (i = stack_base - 1; i > stack_ptr; i--) {
  //printf("%p:\t0x%016llX\n", i, *i);
  //}
  //printf("Étape 6: %llx, %p\n", mem_max, new.mem_ptr);
    
  return new;
}
