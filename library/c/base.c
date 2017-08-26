#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "types.h"

#ifdef __linux__
#define write		_write
#define read		_read
#define f_open		_f_open
#define p_open		_p_open
#define f_write		_f_write
#define f_read		_f_read
#define f_close		_f_close
#define format		_format
#define scan		_scan
#define output		_output
#define input		_input
#define err		_err
#endif

static FILE *curout;
static FILE *curin;

int write(quad i, int loc)
{
  int type = i & 7;
  quad val = i >> 3;
  int first = 0;
  FILE *where;

  if (loc == FALSE) where = stdout;
  else where = curout;

  switch(type) {
  case ADDRESS:
    fprintf(where, "%lld", val);
    break;
  case SPECIAL:
    switch(i) {
    case FALSE:
      fprintf(where, "false");
      break;
    case TRUE:
      fprintf(where, "true");
      break;
    case NIL:
      fprintf(where, "nil");
      break;
    }
    break;
  case STRING:
    fprintf(where, "%s", (char*)(val + 8));
    break;
  case TABLE:
    fprintf(where, "table: %p", (quad*) val);
    break;
  case OBJECT:
    switch (*(quad*)val) {
    case O_FILE:
      if (*(quad*)val == NIL) fprintf(where, "nil");
      else fprintf(where, "file (0x%llx)", *(quad*)(val + 8));
      break;
    }
    break;
  case STACK:
    while (*(int*)val != 33) {
      if (first) fprintf(where, "\t");
      else first = 1;
      _write(val, loc);
      val = val - 8;
    }
    break;
  case DOUBLE:
    fprintf(where, "%.13g", *(double *) val);
    break;
  case FUNCTION:
    fprintf(where, "function: 0x%llx", *(quad*) val);
    break;
  }
  return VOID;
}

FILE *f_open(char *filename, char *mode)
{
  FILE *f = fopen(filename, mode);
  if (f == NULL) return (FILE*)-1;
  return f;
}

quad p_open(char *filename, char *mem, quad max, char *mode)
{
  FILE *fp = popen(filename, mode);
  quad i = 0;
  
  if (fp != NULL) {
    i = fread(mem + 8, 1, max, fp);
    mem[i + 8] = 0;
    fclose(fp);
  } else return -1;
  quad *len = (quad*)mem;
  *len = i;
  return i + 9;
}

void f_write(FILE *file, quad arg)
{
  int type = arg & 7;
  quad val = arg >> 3;
  if (type == DOUBLE)
    fprintf(file, "%.13g", *(double*)val);
  else
    fputs(file, (char*)(val + 8));
}

quad f_read(FILE *file, char *mem, char *mode, int max)
{
  quad i = 0;
  char c = fgetc(file);
  char t[3];
  if ((quad)mode != NIL) {
    if (mode[0] == "*") {
      
  
  if (c == EOF) return -1;
  else ungetc(c, file);
  if ((quad)file == NIL) file = curin;
  if ((quad)mode == NIL) {
    fscanf(file, "%s", mem + 8);
      for (i = 0; ; i++)
	if (!mem[8 + i]) break;
  }
  else if ((quad)mode == VOID || !strcmp(mode, "all") || !strcmp(mode, "*all")) {
    i = fread(mem + 8, 1, max, file);
    mem[i + 8] = 0;
  }
  else if (!strcmp(mode, "line") || !strcmp(mode, "*line")) {
    for (i = 0; i < max; i++) {
      c = fgetc(file);
      if (c == EOF) break;
      if (c == '\n') break;
      mem[i + 8] = c;
    }
    mem[i + 8] = 0;
  }
  else if (!strcmp(mode, "number") || !strcmp(mode, "*number")) {
    fscanf(file, "%lf", (double*)mem);
    return -2;
  }

  quad *len = (quad*)mem;
  *len = i;

  return i + 9;
}

void f_close(FILE *file)
{
  if ((quad)file == NIL)
    fclose(curout);
  else
    fclose(file);
}

void f_flush(FILE *file)
{
  if ((quad)file == NIL)
    fflush(curout);
  else
    fflush(file);
}

void f_seek(FILE *file, int whence, int offset)
{
  fseek(file, whence, offset);
}

quad format(char *mem, char *spec, quad obj)
{
  int type = obj & 7;
  quad val = obj >> 3;
  switch(type) {
  case ADDRESS:
    sprintf(mem + 8, spec, (quad)val);
    break;
  case STRING:
    sprintf(mem + 8, spec, (char*)(val + 8));
    break;
  case DOUBLE:
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

void output(quad ptr)
{
  if (ptr == NIL) {
    curout = stdout;
    return;
  }
  if (curout != stdout) fclose(curout);
  char *filename = (char*)(ptr + 8);
  curout = fopen(filename, "a+");
  if (curout == NULL) curout = stdout;
}

void input(quad ptr)
{
  if (ptr == NIL) {
    curin = stdin;
    return;
  }
  if (curin != stdin) fclose(curin);
  char *filename = (char*)(ptr + 8);
  curin = fopen(filename, "r");
  if (curin == NULL) curin = stdin;
}

void err(quad *mem)
{
  mem[0] = 1;
  mem[1] = (quad)stderr;
}
