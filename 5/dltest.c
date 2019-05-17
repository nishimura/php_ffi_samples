#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <string.h>

#include "template_operations.h"

static void* lib;
static char struct_ret[1024];

size_t cb(const char *key, const char *value)
{
  printf("call cb: %s\n", key);

  void (*setter)(const char *value);
  setter = dlsym(lib, "assign_value_set");

  sprintf(struct_ret, "%s = %s", key, value);
  size_t len = strlen(struct_ret);
  //strncpy(struct_strlen.str, retp, len);
  setter(struct_ret);

  return len;
}

int main(int argc, char *argv[])
{
  printf("dltest main\n");
  lib = dlopen("./libcallback.so", RTLD_LAZY);
  if (lib == NULL) {
    printf("%s\n", dlerror());
    exit(1);
  }

  int (*init)();
  int (*finish)();
  init = dlsym(lib, "prepare");
  finish = dlsym(lib, "finish");
  init();

  const char* (*parse)(char *data, CTOPS *tops);
  parse = dlsym(lib, "parse");

  CTOPS tops = { cb };
  char *a = "init";
  const char *ret = parse(a, &tops);
  printf("parse: %s\n", ret);

  const char * (*getter)();
  getter = dlsym(lib, "assign_value_get");
  const char *v = getter();

  printf("buf: %s\n", v);


  finish();

  dlclose(lib);
  return 0;
}
