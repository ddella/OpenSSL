# OpenSSL 3.0.7 - Nov 2022
This is an **OpenSSL** cheat sheet on OpenSSL 3.x and with both **RSA** and **ECC** keys in mind.  

## OpenSSL Cheat Sheet
OpenSSL is a versatile command line tool that can be used for a large variety of tasks related to Public Key Infrastructure (PKI). This cheat sheet provides a quick reference to OpenSSL commands that are useful in everyday scenarios. This includes **OpenSSL** examples for generating private/public keys, certificate signing requests, certificate format conversion and much more.

All the example below have been tested with OpenSSL 3.x.y on a macOS but should work without any problems on Linux or Windows.

Throughout the examples, I might used different file extensions. All the files are in `PEM` format, unless otherwise specified. The extension has no imptact on the file format.
***
## Encryption
OpenSSL commands to encrypt/decrypt with either RSA or ECC keys. I will cover symmetric and asymmetric encryptions.  
[Encryption](/Encryption)
***
## Certificate Chain of trust with RSA and ECC
OpenSSL commands to verify certificate signature with either RSA or ECC  
[Certificate Chain of trust](/Certificate%20Chain%20of%20trust)
***
## Private and Public keys (RSA and ECC)
OpenSSL commands to generate, view and check Private and Public Keys with either RSA or ECC.  
1. [ECC Private and Public Keys](ECC-PPK)
2. [RSA Private and Public Keys](RSA-PPK)
3. [ECC key anatomy](ECC-Anatomy)
3. [RSA key anatomy](RSA-Anatomy)
***
## Generate Certificate Chain with Elliptic Curve keys
In this section we will generate a full certificate chain.
1. RootCA certificate
2. Intermediate CA certificate
3. Server certificate  

[ECC Certificate Chain](/ECC%20Certificate%20Chain)
***
## OpenSSL Utilities
Different utilities with OpenSSL  
[Utilities](/Utilities)
***
## OpenSSL Cipher suite test on TLS servers
Shell script to test ciper suites of a TLS server  
[Cipher Suite Test](/Cipher%20suite%20test)
***
## Compile OpenSSL on macOS
macOS comes with an old version of OpenSSL. Follow these steps to have the newest version without erasing the stock one.  
[Compile OpenSSL](/Compile%20OpenSSL)
***
