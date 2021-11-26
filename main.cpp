#include <string.h>
#include <stdlib.h>
#include <iostream>
#include "hello.h"

int
main (int argc, char *argv[])
{
  Rawrr R;

  R.setDomainName("Hello");
  R.createObject ();
  R.setRawFile("hello.h");
  R.openFile();
  R.get_info();

  return (0);

}
