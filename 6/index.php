<?php
header('Content-Type: text/plain');
$ffi = FFI::cdef('
int hs_init(int *, char **[]);
int hs_exit();

typedef struct template_operations
{
  size_t (*assign)(const char * key, const char * value);
} CTOPS;

const char* parse(char *data, struct template_operations *tops);
void return_value_set(const char *value);
const char * return_value_get();

', __DIR__ . '/libcallback.so');

$argc = FFI::new('int');
$argv = FFI::new('char[0]');
$pargv = FFI::addr($argv);
$ffi->hs_init(FFI::addr($argc), FFI::addr($pargv));

$tops = $ffi->new('struct template_operations');
$tops->assign = function($key, $value) use ($ffi){
    $value = "$key = $value";
    $ffi->return_value_set($value);

    // Notice:
    // return string value is not supported
    return strlen($value);
};

$data = '<div>$foo</div>';
$ret = $ffi->parse($data, FFI::addr($tops));

var_dump($ffi->return_value_get());
var_dump($ret);


$ffi->hs_exit();


/*
 Output

string(9) "foo = bar"
string(30) "hsParse finish: [9][foo = bar]"

 */
