# Compile OpenSSL from source on macOS - 3.0.7 - Nov 2022
Steps to download the latest OpenSSL version and compile it on macOS.
## Compile OpenSSL
Clone the latest version for GitHub
```shell
git clone https://github.com/openssl/openssl.git
```
Change directory to the source tree
```shell
cd openssl
```
**Optional:** Edit the file at line 91: `include/openssl/opensslv.h.in` to include your personal touch
```
# define OPENSSL_VERSION_TEXT "OpenSSL Compiled by <Your name/Cie> 20221101 {- "$config{full_version} $config{release_date}" -}"
```
Compile OpenSSL. Make sure you have the compiler installed. For macOS, you need `Xcode cli` tools. Be patient, that will take some time. I choosed to have the binaries in `~/bin/openssl`.
```shell
mkdir build
cd build
../Configure darwin64-x86_64 --debug --prefix=/Users/<username>/bin/openssl --openssldir=/Users/<username>/bin/openssl
make 
make test
make install
```
Add this new OpenSSL directory to your path. For macOS, edit the file `~/.zshrc` and add the following at the end:
```shell
# OpenSSL 3.0.7
export PATH=~/bin/openssl/bin/:$PATH
export MANPATH="$(manpath):/Users/<username>/bin/openssl/share/man"
```
## clean up
Just delete the source tree used to compile OpenSSL.
```shell
cd ../..
rm -rf openssl
```
## Test
Open a terminal window and type
```shell
openssl version
```
You should get something similar:
```
OpenSSL Compiled by <Your name/Cie> 20221101 3.0.7 1 Nov 2022 (Library: OpenSSL Compiled by <Your name/Cie> 20221104 3.0.7 1 Nov 2022)
```
***
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#Compile-OpenSSL-from-source-on-macOS---3.0.7---Nov-2022)  
[_< back to root_](../../../)
