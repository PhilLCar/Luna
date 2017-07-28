#include <stdlib.h>

struct Bob {
  int a;
  double b;
  char* c;
};

struct Bob lol(int a, float b, char* c) {
  struct Bob bob;
  bob.a = a;
  bob.b = b;
  bob.c = c;
  return bob;
}

int test(int a, int b, int c, int d, int e, int f, int g, int h) {
  //lol(a, (int)b, "a");
  return a + b + c + d + e + f + g + h;
}
