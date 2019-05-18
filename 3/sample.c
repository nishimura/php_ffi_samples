#include <string.h>

#define BUF_SIZE 1024

typedef int (*callback_t)(int);

const char * sample(const char *data, callback_t callback)
{
  char buf[BUF_SIZE];
  const char * ret = buf;
  int i;

  for (i = 0; i <= strlen(data) && BUF_SIZE; i++){
    if (data[i] >= 97 && data[i] <= 122 && callback(i))
      buf[i] = data[i] - 32;
    else
      buf[i] = data[i];
  }

  return ret;
}
