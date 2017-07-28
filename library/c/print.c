#include <stdio.h>

long lint(long i) {
  return i >> 3;
}

long cint(long i) {
  return i << 3;
}

char* lstr(long s) {
  s >>= 3;
  return (char*)(s + 8);
}

long cstr(char* s) {
  long r = (long)s;
  r <<= 3;
  return r + 2;
}

int print(long i) {
  printf("%d\n", lint(i));
}
