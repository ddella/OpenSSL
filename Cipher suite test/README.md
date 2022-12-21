# OpenSSL Cipher suite test
## Testing Cipher Suite Support
This is a little script if you wish to use OpenSSL to determine what cipher suite a remote server supports. The cipher configuration string is designed to select which suites you wish to use, but if you specify only one suite and successfully handshake with a server, then you know that the server supports the suite. If the handshake fails, you know the support is not there.

If you want to determine all suites supported by a particular server, start by invoking **openssl ciphers ALL** to obtain a list of all suites supported by your version of OpenSSL. Then submit them to the server one by one to test them individually. This is exactly what this script does.

>P376: BULLETPROOF SSL AND TLS from Ivan Ristić

## OpenSSL Cipher suite test
Shell script to test CIPHER suites supported on a TLS server.

1. It queries OpenSSL for a list of supported CIPHER suites
2. It initiate a TLS connection to the server, using each of the cipher
3. Capture the results from OpenSSL

If the handshake is successful, it prints **YES**. If the handshake isn't successful, it prints **NO**, followed by the OpenSSL error.
 
 Example of the output of the script:
>Testing ECDHE-ECDSA-AES256-GCM-SHA384...YES  
>Testing ECDHE-RSA-AES256-GCM-SHA384...NO (sslv3 alert handshake failure)  

## How to use
Replace with the hostname, port number and TLS version you want to test.
```shell
./test_ciphers.sh localhost:8443 tls1_2
```

## Tested
The script has been tested with **TLS 1.2** and T**LS 1.3**.  
It works with **bash** and **zsh** on both macOS and Linux.  

## Requirements
Make sure you have the **chain of trust** in the file **`chain.pem`**. In this case it must contain ALL the certificates in a PEM file to avoid the anoying error: '21 (unable to verify the first certificate)':
1. Server certificate
2. SubRootCA certificate
3. RootCA certificate

In the example below, I have the three certificates in the file **`chain.pem`**:

```
-----BEGIN CERTIFICATE-----
MIIDUTCCAvegAwIBAgIUOmdAyUWsVABpHt2vhB5E7xFnwGcwCgYIKoZIzj0EAwIw
[...]
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDSzCCAvGgAwIBAgIUNykNbc3v611Q/dQPubEmNxbRBzIwCgYIKoZIzj0EAwIw
[...]
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDOzCCAuCgAwIBAgIUFnTj4mss+lvg8dQ0jfVH5vUuIW8wCgYIKoZIzj0EAwIw
[...]
-----END CERTIFICATE-----
```

## What it does
The script simply use OpenSSL to initiate a TLS connection with the server and specifies the cipher.  

Example of the OpenSSL command to test a cipher against a server with **TLS 1.2**:
```shell
openssl s_client -cipher ECDHE-ECDSA-AES256-CCM8 -tls1_2 -CAfile chain.pem -connect localhost:8443 <<< /dev/null
```

Example of the OpenSSL command to test a cipher against a server with **TLS 1.3**:
```shell
openssl s_client -ciphersuites TLS_AES_256_GCM_SHA384 -tls1_3 -CAfile chain.pem -connect localhost:8443  <<< /dev/null
````

>**Note**: The cipher argument is different within OpenSSL for TLS 1.2 and TLS 1.3  
>> `-cipher <value>          Specify TLSv1.2 and below cipher list to be used`  
>> `-ciphersuites <value>    Specify TLSv1.3 ciphersuites to be used`  

## Thanks to
I took the base code here:  
https://superuser.com/questions/109213/how-do-i-list-the-ssl-tls-CIPHER-suites-a-particular-website-offers

I added support for:
1. **zsh** shell on macOS
2. TLS 1.3

## License

This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#OpenSSL-Cipher-suite-test)