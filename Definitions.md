# Definitions
## PEM file
A PEM file is a `base64` encoded text file that usually represents a certificate or a key. Once Base64 decoded, they are just ANSI [X.690](https://en.wikipedia.org/wiki/X.690) encoded DER objects. The easiest way to understand their structure is to use `openssl asn1parse` on them.

## RSA encryption maximum data size
RSA is only able to encrypt data to a maximum amount equal to your key size (2048 bits = 256 bytes), minus any padding and header data (11 bytes for PKCS#1 v1.5 padding). As a result, it is **not** possible to encrypt files with RSA directly and RSA is not designed for this.  

Usually asymmetric encryption does the following:
1. Generate a 256-bit random key *k*
2. Encrypt your data with *K*
3. Encrypt *K* with **RSA**
4. Send the *k* in the header of the encrypted data

## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Definitions)  
[_< back to root_](README.md)
