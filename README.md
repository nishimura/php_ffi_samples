PHP FFI Samples
===============

2019/05/18



## Compile PHP 7.4

```bash
mkdir work
cd work

git clone https://github.com/php/php-src.git
cd php-src
git checkout PHP-7.4
./configure --with-ffi
make

cd ..
```



## Checkout Samples

```bash
git clone https://github.com/nishimura/php_ffi_samples.git
```



## Start Server with FFI

```bash
cd php_ffi_samples
../php-src/sapi/cli/php -d ffi.enable=1 -S localhost:8000

# and access to
#   http://localhost:8080/
#   http://localhost:8080/1/
#   ...
```



## Create DSO Module

require: c build tools

```bash
cd 2
make

# and access to
#   http://localhost:8080/2/
```



## Other Samples

* 3: call with closure argument
* 4: c struct, php reference and callback
* 5: FFI bridge
* 6, 7: call haskell functions directly



## FFI Bridge to Haskell

require: haskell build tools (ghc)

### sample5

PHP => FFI C => FFI Haskell => Callback C => Callback PHP => Set c variable instead of return value

### sample6, sample7

PHP => FFI Haskell Callback PHP => Set haskell IORef instead of return value

