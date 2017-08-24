#include <stdio.h>
#include <string.h>

#ifdef __linux__
#define write	_write
#define read	_read
#define open	_open
#define p_open	_p_open
#define f_write	_f_write
#define f_read	_f_read
#define f_close	_f_close
#define format	_format
#define scan	_scan
#endif

typedef long long quad;

int write(quad i)
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
      _write(val);
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

quad read(char *mem)
{
  quad i = 0;
  scanf("%s", &mem[8]);
  
  for (i = 0; ; i++)
    if (!mem[8 + i]) break;
  
  quad *len = (quad*)mem;
  *len = i;
  
  return i + 9;
}

FILE *open(char *filename, char *mode)
{
  return fopen(filename, mode);
}

quad p_open(char *mem, char *filename, int max)
{
  FILE *fp = popen(filename, "r");
  quad i = 0;
  if (fp == NULL) {
    return 9;
  }
  if (fgets(mem, max, fp) != NULL)
    for (i = 0; ; i++)
      if (!mem[8 + i]) break;
  
  quad *len = (quad*)mem;
  *len = i;

  return i + 9;
}

void f_write(FILE *file, char *what)
{
  fputs(what, file);
}

quad f_read(char *mem, char *filename, int max)
{
  FILE *fp = fopen(filename, "r");
  quad i = 0;
  if (fp == NULL) {
    return 9;
  }
  if (fgets(mem, max, fp) != NULL)
    for (i = 0; ; i++)
      if (!mem[8 + i]) break;
  
  quad *len = (quad*)mem;
  *len = i;

  return i + 9;
}

void f_close(FILE *file)
{
  fclose(file);
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
  quad i;
  for (i = 0; ; i++)
    if (!mem[8 + i]) break;
  
  quad *len = (quad*)mem;
  *len = i;
  
  return i + 9;
}

double scan(char *str)
{
  double c;
  sscanf(str, "%lf", &c);
  return c;
}
