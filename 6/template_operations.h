typedef struct template_operations
{
  size_t (*assign)(const char * key, const char * value);
} CTOPS;
