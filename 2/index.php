<?php

header('Content-Type: text/plain');

$ffi = FFI::cdef("

const char * sample(const char *data, int mod);

", __DIR__ . '/libsample.so');

var_dump($ffi);
var_dump($ffi->sample("sample test test", 3));
var_dump($ffi->sample("sample test test", 4));
var_dump($ffi->sample("sample test test", 1));

/* output:

object(FFI)#1 (0) {
}
string(16) "SamPle teSt TesT"
string(16) "SampLe tEst Test"
string(16) "SAMPLE TEST TEST"

 */
