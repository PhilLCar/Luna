#include <stdio.h>

#ifdef __linux__
#define print _print
#endif

typedef long long quad;

int print(quad i) {
  int type = i & 7;
  quad val = i >> 3;
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
    printf("table: %p", (quad*) val);
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
    printf("function: 0x%x", *(quad*) val);
    break;
  }
  return 33;
}
