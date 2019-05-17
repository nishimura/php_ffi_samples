<?php

header('Content-Type: text/plain');

$ffi = FFI::cdef("


typedef int (*callback_t)(int);
struct cbdata {
  callback_t f;
};

const char * sample(const char *data, struct cbdata *cbdata);

", __DIR__ . '/libsample.so');

$cbdata = $ffi->new('struct cbdata');
$n = 3;
$cbdata->f = function($i) use(&$n){
    return $i % $n === 0;
};

$pcbdata = FFI::addr($cbdata);

var_dump($ffi->sample("sample test test", $pcbdata));

$n = 4;
var_dump($ffi->sample("sample test test", $pcbdata));

$n = 1;
var_dump($ffi->sample("sample test test", $pcbdata));

/*

 output:

string(6) "SamPle"
string(6) "SampLe"
string(6) "SAMPLE"

 */
