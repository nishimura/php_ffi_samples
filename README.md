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
```



## Checkout Samples

```bash

```



## Start Server with FFI

```bash
cd php_ffi_samples
../php-src/sapi/cli/php -d ffi.enable=1 -S localhost:8000

# and access to
#   http://localhost:8080/1/
#   http://localhost:8080/2/
#   ...
```

