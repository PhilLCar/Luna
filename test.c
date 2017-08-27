#include <stdio.h>

int main() {
  //io.write("[ \27[1;38;5;47m" .. string.format("%4d", pass) .. "\27[0m ]")
  printf("[ \33[1;38;5;47m%4d\33[0m ]", 34);
  return 0;
}
