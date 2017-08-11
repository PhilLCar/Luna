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
  int type = i & 7;
  long val = i >> 3;
  int first = 0;
  switch(type) {
  case 0:
    printf("%d\n", val);
    break;
  case 1:
    if (!val)
      printf("false\n");
    else if (val == 1) 
      printf("true\n");
    else if (val == 2)
      printf("nil\n");
    break;
  case 2:
    printf("%s\n", (char*)(val + 8));
    break;
  case 5:
    while (*(int*)val != 33) {
      if (first) printf("\t");
      else first = 1;
      print(val);
      val = val + 8;
    }
  break;
  case 6:
    printf("%.13g\n", *(double *) val);
    break;
  }
  return 1;
}
