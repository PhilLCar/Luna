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
#define STRING   2
#define TABLE    3
#define EMPTY    4
#define STACK    5
#define DOUBLE   6
#define FUNCTION 7

quad *stack_base;
quad *mem_size;
quad *mem_max;

struct Mem gc(quad *stack_ptr, quad *mem_ptr, quad *mem_base) {
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
