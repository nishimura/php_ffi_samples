#include <stdio.h>
#include <HsFFI.h>

#ifdef __GLASGOW_HASKELL__
#include "Callback_stub.h"
#endif

#include "template_operations.h"

int prepare() {
  hs_init(0,0);
}
int finish() {
  hs_exit();
}

static const char * assign_string = "";
void assign_value_set(const char *value)
{
  assign_string = value;
}
const char *assign_value_get()
{
  return assign_string;
}

const char* parse(char *data, struct template_operations *tops)
{
  return hsParse(data, tops);
}
