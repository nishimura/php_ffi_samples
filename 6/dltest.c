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
  setter = dlsym(lib, "return_value_set");

  sprintf(struct_ret, "%s = %s", key, value);
  size_t len = strlen(struct_ret);
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

  int (*hs_init)(int *, char **[]);
  int (*hs_exit)();
  hs_init = dlsym(lib, "hs_init");
  hs_exit = dlsym(lib, "hs_exit");
  hs_init(&argc, &argv);

  const char* (*parse)(char *data, CTOPS *tops);
  parse = dlsym(lib, "parse");

  CTOPS tops = { cb };
  char *a = "init";
  const char *ret = parse(a, &tops);
  printf("parse: %s\n", ret);

  const char * (*getter)();
  getter = dlsym(lib, "return_value_get");
  const char *v = getter();

  printf("buf: %s\n", v);


  hs_exit();

  dlclose(lib);
  return 0;
}
