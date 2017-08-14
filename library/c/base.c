#include <stdio.h>

long _lint(long i) {
  return i >> 3;
}

long _cint(long i) {
  return i << 3;
}

char* _lstr(long s) {
  s >>= 3;
  return (char*)(s + 8);
}

long _cstr(char* s) {
  long r = (long)s;
  r <<= 3;
  return r + 2;
}

int _print(long i) {
  int type = i & 7;
  long val = i >> 3;
  int first = 0;
  switch(type) {
  case 0:
    printf("%d", val);
    break;
  case 1:
    if (!val)
      printf("false");
    else if (val == 1) 
      printf("true");
    else if (val == 2)
      printf("nil");
    break;
  case 2:
    printf("%s", (char*)(val + 8));
    break;
  case 3:
    printf("table: %p", (void*) val);
    break;
  case 5:
    while (*(int*)val != 33) {
      if (first) printf("\t");
      else first = 1;
      _print(val);
      val = val + 8;
    }
  break;
  case 6:
    printf("%.13g", *(double *) val);
    break;
  case 7:
    printf("function: %p", (void*) val);
    break;
  }
  return 0;
}
