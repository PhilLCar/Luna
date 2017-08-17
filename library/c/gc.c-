#include <stdio.h>
#include <errno.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>

typedef long long quad;

#ifdef __linux__
#define stack_base  _stack_base
#define stack_ptr   _stack_ptr
#define mem_ptr     _mem_ptr
#define mem_base    _mem_base
#define mem_size    _mem_size
#define global_size _global_size
#define gc          _gc
#define gain        _gain
#endif

#define Q(x) ((quad*)(x))
#define C(x) ((char*)(x))

quad *stack_ptr;
quad *stack_base;
void *mem_ptr;
char *mem_base; //char
quad  mem_size;
quad  global_size = 0;
quad  gain;  // After compaction check if necessary room gained or trigger realloc

char *copy;
char *scan;
quad heartbreaker = 0xE000000000000000;
quad stag         = 0x3000000000000003;

// Prototypes
void  copyglobals();
void  placeroots();
int   heartbroken(quad);
quad  heartbreak(quad);
quad  reconcile(quad);
void  memcopy(quad*);
void  memscan();
int   ispointer(quad);
int   blocksize(quad);
char *rgc(quad);

// Utilité d'impression pour le debugging
void printmem(char *from, char *to) {
  int k;
  for (k = 0; k < 84; k++) fprintf(stderr, "=");
  printf("\n\n");
  for (k = 0; k < 40; k++){
    fprintf(stderr, "From :: %016llX | %p |", *(Q(from) + k), Q(from) + k);
    printf("| To :: %016llX | %p\n", *(Q(to) + k), Q(to) + k);
  }
}

char* gc()
{
  /*** En raison de problèmes rencontrés lors de la compilation de mmap avec un des ordinateurs
   le call est effectué depuis le fichier assembleur et le pointeur est passé a mem_ptr ***/
  copy = mem_ptr;
  copyglobals();
  placeroots();
  scan = mem_ptr;
  while (copy != scan) {
    memscan();
  }

  // Freeing the from space
  munmap(mem_base, mem_size);
  
  mem_base = mem_ptr;

  // Is memory full?
  if (mem_base + mem_size - copy <= gain) {
    return rgc(2 * mem_size);
  }
  return copy;
}

char* rgc(quad new_size)
{
  /*** Mêmes problèmes que dans le gc ordinaire ***/
  mem_ptr = mmap(NULL, new_size * sizeof *mem_ptr, PROT_READ | PROT_WRITE | PROT_EXEC,
	     MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
  copy = mem_ptr;
  copyglobals();
  placeroots();
  scan = mem_ptr;
  while (copy != scan) {
    memscan();
  }

  // Freeing the from space
  munmap(mem_base, mem_size);
  
  mem_base = mem_ptr;
  mem_size = new_size;

  // Is memory full?
  if (mem_base + mem_size - copy <= gain) {
    return rgc(2 * mem_size);
  }
  return copy;
}

// Copie la table de variables globales à l'avant de la nouvelle plage mémoire
void copyglobals()
{
  int i;
  for (i = 0; i < global_size; i++)
    *(copy + i) = *(mem_base + i);
  copy += global_size;
}

// Copie la mémoire tout en ajustant les pointeurs et les hearbreak
void memcopy(quad *ptr)
{
  int j;
  int size = blocksize(*ptr);
  int type = *ptr & 7;
  quad *tmp = Q(*ptr >> 3);
  if (heartbroken(*tmp)) {
    *ptr = (reconcile(*tmp) << 3) + type;
    return;
  }
  if (type == 3 || type == 5) {
    *tmp ^= stag;
  }
  for (j = 0; j < size; j++) {
    *(copy + j) = *(C(tmp) + j);
  }
  *ptr = ((quad)copy << 3) + type;
  *tmp = heartbreak((quad)copy);
  copy += j;
}

void placeroots()
{
  quad *ptr, *i;
  for (i = stack_ptr; i < stack_base; i += 1) {
    if (ispointer(*i))
      memcopy(i);
  }
  for (i = Q(mem_base); i < Q(mem_base + global_size); i += 1)
    if (ispointer(*i))
      memcopy(i);
}

int heartbroken(quad value)
{
  return (((value >> 56) & 0xFF) == 0xE0) && value & 1;
}

quad heartbreak(quad value)
{
  return ((value << 4) ^ heartbreaker) + 1;
}

quad reconcile(quad value)
{
  return (value ^ heartbreaker) >> 4;
}

void memscan()
{
  if (!ispointer(*Q(scan))) {
    scan += 8;
    return;
  }
  
  // If the memory field is S-tagged, remove the tag and jump over the tagged zone
  if ((*Q(scan) & stag) == stag) {
    *Q(scan) ^= stag;
    scan += (*Q(scan) >> 3) + 1;
  }
  else
    memcopy(Q(scan));
  scan += 8;
}

int ispointer(quad value)
{
  if ((value & 7) == 2) return value > 2048; // Max char size
  if ((value & 7) < 3) return 0;
  if (value == 6) return 0;
  return 1;
}

int blocksize(quad value)
{
  int tag = value & 7;
  if (tag < 3) return 8;
  quad pointed = *Q(value >> 3);
  if (tag == 4) return pointed + 8;
  if (tag > 5) return 16;
  return (pointed >> 3) + 9;
}

// Un jour
void listcopy() {

}
