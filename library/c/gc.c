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
#define STRING   2
#define TABLE    3
#define EMPTY    4
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

  if (trf_mask & data) return (*P(trf_mask ^ data) ^ heartbreaker) | trf_mask;
  else if (type == ADDRESS || type == SPECIAL || type == EMPTY) return data;
  else if (*point & heartbreaker) return (*point << 3) | type;
  
  switch(type) {

  case STRING:
    *copy = *(point++);
    //*(point++) = heartbreaker | Q(copy);
    base = copy++;
    //printmem(base, 8);
    max = *base;
    for (i = 0; i <= max; i++)
      C(copy)[i] = C(point)[i];
    copy = P(C(copy) + max + 1);
    return (Q(base) << 3) | STRING;

  case TABLE:
    *copy = *point;
    *(point++) = heartbreaker | Q(copy);
    base = copy;
    copy += 3;
    // Copy linked list sequence
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
    
  case STACK:
    ////printmem(point, 20);
    // Seek end
    for (size = 0; point[-size] != VOID; size++);
    base = copy + size;
    copy = base + 1;
    for (i = 0; i <= size; i++)
      base[-i] = copydata(point[-i]);
    ////printmem(base, 20);
    point[0] = heartbreaker | Q(base);
    return (Q(base) << 3) | STACK;
    
  case DOUBLE:
    *copy = *point;
    //*point = heartbreaker | Q(copy);
    return (Q(copy++) << 3) | DOUBLE;
    
  case FUNCTION:
    *copy = *point;
    *(point++) = heartbreaker | Q(copy);
    base = copy;
    copy += 2;
    // Copy closure environment linked list
    copyll(point, base + 1);
    return (Q(base) << 3) | FUNCTION;
  }
  return NIL;
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
  int i;
  printf
    ("-------------------------------------------------------------------------------------------\n");
  for (i = lines / 4 - 1; i >= 0; i--)
    printf("%2d:%016llx\t%2d:%016llx\t%2d:%016llx\t%2d:%016llx\n",
	   i, *(start + i),
	   i + lines / 4, *(start + i + lines / 4),
	   i + lines / 2, *(start + i + lines / 2),
	   i + lines / 4 * 3, *(start + i + lines / 4 * 3));
  printf
    ("-------------------------------------------------------------------------------------------\n");
}

// Peut-être appeler le GC dans les boucles aussi!
vals gc(quad *stack_ptr, quad *mem_ptr, quad *mem_base)
{
  vals new;
  quad *i;
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
  //printmem(mem_base, 48);
  
  if (copy == MAP_FAILED) {
    fprintf(stderr, "Memory allocation failed (Process aborted)\n");
    exit(1);
  }
  
  // Globals
  copydata((Q(mem_base) << 3) | TABLE);
  //printmem(new.mem_base, 48);
  //printf("Étape 2\n");
  // Stack
  for (i = stack_base - 1; i > stack_ptr; i--) {
    //printf("%p:\t0x%016llX\n", i, *i);
    *i = copydata(*i);
    //printmem(new.mem_base, 48);
    //printf("%p:\t0x%016llX\n", i, *i);
  }
  //printf("Étape 3\n");
  // Closure environmnet
  copyll(i, i);
  //printf("Étape 4\n");

  munmap(mem_ptr, mem_size);
  //printf("Étape 5\n");

  new.mem_ptr  = copy;

  // Resizing -- if compacted data is over the max, the GC would perpetually be called
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
  }
  mem_max = Q(new.mem_base) + (mem_size / 4 * 3);
  //printmem(new.mem_base, 48);
  //for (i = stack_base - 1; i > stack_ptr; i--) {
  //printf("%p:\t0x%016llX\n", i, *i);
  //}
  //printf("Étape 6: %llx, %p\n", mem_max, new.mem_ptr);
    
  return new;
}
