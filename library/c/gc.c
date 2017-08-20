#include <stdio.h>
#include <errno.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>

typedef long long quad;

struct Mem {
  quad *new_base;
  quad *new_ptr;
};

#ifdef __linux__
#define stack_base  _stack_base
#define mem_size    _mem_size
#define mem_max     _mem_max
#define gc          _gc
#endif

#define P(x) ((quad*)(x))
#define C(x) ((char*)(x))
#define Q(x) ((quad)(x))
#define B(x) ((char)(x))

#define INTEGER  0
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
quad *mem_size;
quad *mem_max;

quad *scan;
quad *copy;

quad heartbreaker = 0xE000000000000000;

quad copydata(quad data)
{
  int type = data & 7;
  quad *point = P(data >> 3);
  quad *base, *p;
 
  if (*point & heartbreaker) {
    *copy = (*point << 3) | type;
    return *(copy++);
  }
  switch(type) {
  case INTEGER:
    return data;
  case SPECIAL:
    return data;
  case STRING:
    *copy = *point;
    *(point++) = heartbreaker | Q(copy);
    base = copy++;
    point++;
    while (1) {
      *C(copy) = *C(data);
      copy = P(C(copy) + 1);
      if (C(point) == 0) break;
      point = P(C(point) + 1);
    }
    return (Q(base) << 3) | STRING;
  case TABLE:
    *copy = *point;
    *(point++) = heartbreaker | Q(copy);
    base = copy++;
    // Copy linked list sequence
    quad *last = copy;
    while (*point != NIL) {
      quad a, b;
      point = P(*point);
      a = copydata(*point);
      b = copydata(*(point + 1));
      *copy = a;
      *(copy + 1) = b;
      *last = Q(copy);
      last = copy + 2;
      copy = copy + 3;
      point = point + 2;
    }
    *last = NIL;
    // Copy array sequence
    point = p;
    if (*point != nil) {
      p = P(*point);
      *(base + 2) = Q(copy);
      int cap, off, i, first = -1, last;
      cap = *p >> 3;
      *(copy++) = *(p++);
      off = *p >> 3;
      *(copy++) = *(p++);
      for (i = 0; i < cap; i ++) {
	*(copy + i) = *(point + i);
	if (*(copy + i) != NIL) {
	  if (first >= 0) first = i;
	  last = i;
	}
      }
      if ((last - first) * 2 < cap) {
	// RESIZE !!!
      }
      copy = copy + cap;
    } else *(base + 2) = NIL;
    return (Q(base) << 3) | TABLE;
  case EMPTY:
    return data;
  case STACK:
    base = copy;
    while (*point != VOID)
    return (Q(base) << 3) | STRING;
  }
}

void place_globals(quad *mem_base)
{
  
}

void place_roots(quad *mem_base)
{
  
}

struct Mem gc(quad *stack_ptr, quad *mem_ptr, quad *mem_base)
{
  struct Mem mem;
  quad *i;
  /*
    printf("-----------------------------------------\n");
    for (i = stack_base - 1; i >= stack_ptr; i--) {
    printf("%p:\t0x%016llX\n", i, *i);
    }
    printf("-----------------------------------------\n");
  */
  mem.new_ptr  = mem_ptr;
  mem.new_base = mem_base;
  return mem;
}
