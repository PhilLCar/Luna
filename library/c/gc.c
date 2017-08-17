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

quad *stack_base;
quad *mem_size;
quad *mem_max;

struct Mem gc(quad *stack_ptr, quad *mem_ptr, quad *mem_base) {
  struct Mem mem;
  mem.new_ptr  = mem_ptr;
  mem.new_base = mem_base;
  return mem;
}
