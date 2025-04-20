#include "main.h"
#include <stdio.h>

void test() { printf("This is from the header"); }

void fromfunc() { printf("This is from the func"); }
int main(void) {
  test();
  fromfunc();
  printf("Your mom\n");
  return 0;
}
