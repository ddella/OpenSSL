## PEM file
A PEM file is a `base64` encoded text file that usually represents a certificate or a key. Once Base64 decoded, they are just ANSI [X.690](https://en.wikipedia.org/wiki/X.690) encoded DER objects. The easiest way to understand their structure is to use `openssl asn1parse` on them.

