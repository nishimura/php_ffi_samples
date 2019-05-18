<?php

header('Content-Type: text/plain');

$ffi = FFI::cdef("


typedef int (*callback_t)(int);
const char * sample(const char *data, callback_t callback);

", __DIR__ . '/libsample.so');

var_dump($ffi);
var_dump($ffi->sample("sample test test", fn($i) => $i % 3));
var_dump($ffi->sample("sample test test", fn($i) => $i % 4));
var_dump($ffi->sample("sample test test", fn($_) => true));

/* output:

object(FFI)#1 (0) {
}
string(16) "sAMpLE TEsT tESt"
string(16) "sAMPlE TeST tEST"
string(16) "SAMPLE TEST TEST"

 */
