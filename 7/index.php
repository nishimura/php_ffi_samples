<?php
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

', __DIR__ . '/libtemplate.so');

$argc = FFI::new('int');
$argv = FFI::new('char[0]');
$pargv = FFI::addr($argv);
$ffi->hs_init(FFI::addr($argc), FFI::addr($pargv));

$values = [
    'var1' => 'text1',
    'var2' => 'text2',
];

$tops = $ffi->new('struct template_operations');
$tops->assign = function($type, $name) use ($ffi, $values){
    switch ($type){
    case 'var':
        if (isset($values[$name]))
            $v = $values[$name];
        else
            $v = '';
        $ffi->return_value_set($v);

    case 'func':
        // call funcs
        break;

    case 'ctrl':
        // if, foreach, ...
        break;
        
    default:
        return 0;
    }
    return 0;
};

$data = '
<DOCTYPE html>

<div>
  <div>{$var1}</div>
  <span>{$var2}</span>
</div>
';
$ret = $ffi->parse($data, FFI::addr($tops));

echo $ret;


$ffi->hs_exit();


/*
 Output

text1
text2

 */
