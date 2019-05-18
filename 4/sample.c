#include <string.h>

#define BUF_SIZE 1024

typedef int (*callback_t)(int);
struct cbdata {
  callback_t f;
};

const char * sample(const char *data, struct cbdata *cbdata)
{
  char buf[BUF_SIZE];
  const char * ret = buf;
  int i;

  for (i = 0; i <= strlen(data) && BUF_SIZE; i++){
    if (data[i] >= 97 && data[i] <= 122 && cbdata->f(i))
      buf[i] = data[i] - 32;
    else
      buf[i] = data[i];
  }

  return ret;
}
