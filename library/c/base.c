#include <stdio.h>
#include <string.h>

#ifdef __linux__
#define print	_print
#define format	_format
#define scan	_scan
#endif

typedef long long quad;

double scan(char *str)
{
  double c;
  sscanf(str, "%lf", &c);
  return c;
}

quad format(char *mem, char *spec, quad obj)
{
  int type = obj & 7;
  quad val = obj >> 3;
  switch(type) {
  case 0:
    sprintf(mem + 8, spec, (quad)val);
    break;
  case 2:
    sprintf(mem + 8, spec, (char*)(val + 8));
    break;
  case 6:
    sprintf(mem + 8, spec, *(double*)val);
    break;
  default:
    sprintf(mem + 8, spec, val);
    break;
  }
  int i;
  for (i = 0;; i++)
    if (!mem[i + 8]) break;
  
  quad *len = (quad*)mem;
  *len = (quad)i;
  
  return (quad)i + 9;
}

int print(quad i)
{
  int type = i & 7;
  quad val = i >> 3;
  int first = 0;
  switch(type) {
  case 0:
    printf("%lld", val);
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
    printf("function: 0x%llx", *(quad*) val);
    break;
  }
  return 33;
}
