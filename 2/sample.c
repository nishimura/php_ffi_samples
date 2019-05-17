#include <string.h>

#define BUF_SIZE 1024

const char * sample(const char *data, int mod)
{
  char buf[BUF_SIZE];
  const char * ret = buf;
  int i;

  for (i = 0; i <= strlen(data) && BUF_SIZE; i++){
    if (data[i] < 97 || data[i] > 122)
      continue;
    if (i % mod == 0)
      buf[i] = data[i] - 32;
    else
      buf[i] = data[i];
  }

  return ret;
}
