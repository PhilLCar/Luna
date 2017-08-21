#include <stdio.h>
#include <errno.h>
#include <sys/mman.h>
#include <stdlib.h>

void test()
{
  long long *copy;
  copy = (long long*)mmap(NULL,
		     (size_t)1024,
		     PROT_READ | PROT_WRITE | PROT_EXEC,
		     MAP_PRIVATE | MAP_ANON, -1, 0);

  if (copy == MAP_FAILED) {
    fprintf(stderr, "Memory allocation failed (Process aborted)\n");
    exit(1);
  }
  printf("Pointer: %p\n", copy);
  printf("%d\n", errno);
  //err(errno, "%p", copy);
}
