<?php
header('Content-Type: text/plain');
$ffi = FFI::cdef('
int prepare();
int finish();

typedef struct template_operations
{
  size_t (*assign)(const char * key, const char * value);
} CTOPS;

const char* parse(char *data, struct template_operations *tops);
void assign_value_set(const char *value);
const char * assign_value_get();

', __DIR__ . '/libcallback.so');

$ffi->prepare();

$tops = $ffi->new('struct template_operations');
$tops->assign = function($key, $value) use ($ffi){
    $value = "$key = $value";
    $ffi->assign_value_set($value);

    // Notice:
    // return string value is not supported
    return strlen($value);
};

$data = '<div>$foo</div>';
$ret = $ffi->parse($data, FFI::addr($tops));

var_dump($ffi->assign_value_get());
var_dump($ret);


$ffi->finish();


/*
 Output

string(9) "foo = bar"
string(30) "hsParse finish: [9][foo = bar]"

 */
