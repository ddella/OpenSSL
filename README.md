# OpenSSL 3.0.7 - Nov 2022
## OpenSSL Cipher suite test
Shell script to test CIPHER suites on a TLS server. The script works

1. It queries OpenSSL for a list of supported CIPHER suites
2. It initiate a TLS connection to the server, using each of the cipher
3. Capture the results from OpenSSL

If the handshake is successful, it prints **YES**. If the handshake isn't successful, it prints **NO**, followed by the OpenSSL error.

## How to use
```shell
./test_ciphers.sh localhost:8443 tls1_2
```

## Tested
The script has been tested with **TLS 1.2** and T**LS 1.3**.  
It works with **bash** and **zsh** on both macOS and Linux.  

## Requirements
Make sure you have the **chain of trust** in the file **`chain.pem`**. It contains ALL the certificates, RootCA, SubRootCA and server certificate, in a PEM file to avoid the anoying error: '21 (unable to verify the first certificate)'. See below for an example:

```
-----BEGIN CERTIFICATE-----
MIIDUTCCAvegAwIBAgIUOmdAyUWsVABpHt2vhB5E7xFnwGcwCgYIKoZIzj0EAwIw
...
/DHLAiAvxFsENrLF90pEIpt/NQzBhVxmjMfhA5Pr/E0AXGsv7w==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDSzCCAvGgAwIBAgIUNykNbc3v611Q/dQPubEmNxbRBzIwCgYIKoZIzj0EAwIw
...
usc6SGEGHL4uT0q1AS7zCHuBJFPj4g+z9WkYqLX/zQ==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDOzCCAuCgAwIBAgIUFnTj4mss+lvg8dQ0jfVH5vUuIW8wCgYIKoZIzj0EAwIw
...
bXF+iDl8/RxBWFYS9DTE
-----END CERTIFICATE-----
```

## What it does
The script simply use OpenSSL to open a TLS connection with the server and specifies the cipher.  

Example of the OpenSSL command to test a cipher against a server with **TLS 1.2**:
```shell
echo "Q" | openssl s_client -cipher ECDHE-ECDSA-AES256-CCM8 -tls1_2 -CAfile chain.pem -connect localhost:8443
```

Example of the OpenSSL command to test a cipher against a server with **TLS 1.3**:
```shell
echo "Q" | openssl s_client -ciphersuites TLS_AES_256_GCM_SHA384 -tls1_3 -CAfile chain.pem -connect localhost:8443
````

>Note: The cipher argument is different within OpenSSL for TLS 1.2 and TLS 1.3  
>> `-cipher <value>          Specify TLSv1.2 and below cipher list to be used`  
>> `-ciphersuites <value>    Specify TLSv1.3 ciphersuites to be used`  

