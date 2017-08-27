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
#define f_flush		_f_flush
#define f_seek		_f_seek
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

  where = stdout;
  //if (loc == FALSE) where = stdout;
  //else where = curout;

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
    fprintf(where, "table: %lln", (quad*) val);
    break;
  case OBJECT:
    switch (*(quad*)val) {
    case O_FILE:
      if (*(quad*)val == NIL) fprintf(where, "closed file");
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
    fputs((char*)(val + 8), file);
}

quad f_read(FILE *file, char *mem, char *mode, int max)
{
  quad i = 0;
  char c;
  char t = 0;
  if ((quad)mode != NIL) {
    if ((quad)mode == VOID) t = 'a';
    else if (mode[0] == '*') t = mode[1];
    else t = mode[0];
  }
  
  if ((quad)file == NIL) file = curin;
  c = fgetc(file);
  
  if (c == EOF) return -1;
  else ungetc(c, file);
  if (!t) {
    fscanf(file, "%s", mem + 8);
      for (i = 0; ; i++)
	if (!mem[8 + i]) break;
  }
  else if (t == 'a') {
    i = fread(mem + 8, 1, max, file);
    mem[i + 8] = 0;
  }
  else if (t == 'l') {
    for (i = 0; i < max; i++) {
      c = fgetc(file);
      if (c == EOF) break;
      if (c == '\n') break;
      mem[i + 8] = c;
    }
    mem[i + 8] = 0;
  }
  else if (t == 'n') {
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

void f_seek(FILE *file, char *mode, double *o)
{
  int whence;
  int offset;
  if ((quad)mode == NIL) {
    whence = SEEK_SET;
    offset = 0;
  } else if ((quad)o == NIL) {
    offset = 0;
  } else {
    if (!strcmp(mode, "cur")) whence = SEEK_SET;
    else if (!strcmp(mode, "end")) whence = SEEK_END;
    else whence = SEEK_SET;
    offset = (int)*o;
  }
  fseek(file, offset, whence);
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

FILE *output(quad ptr)
{
  if (ptr == NIL) {
    curout = stdout;
    return curout;
  }
  if (curout != stdout) fclose(curout);
  char *filename = (char*)(ptr + 8);
  curout = fopen(filename, "a+");
  if (curout == NULL) curout = stdout;
  return curout;
}

FILE *input(quad ptr)
{
  if (ptr == NIL) {
    curin = stdin;
    return curin;
  }
  if (curin != stdin) fclose(curin);
  char *filename = (char*)(ptr + 8);
  curin = fopen(filename, "r");
  if (curin == NULL) curin = stdin;
  return curin;
}

void err(quad *mem)
{
  mem[0] = 1;
  mem[1] = (quad)stderr;
}
