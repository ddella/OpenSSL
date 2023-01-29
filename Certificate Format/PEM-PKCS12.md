<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# Introduction
PKCS#12 is a common binary format for storing private key(s) and their certificate(s) with or without a complete chain of trust in a single encryptable file. Common file extensions include `.p12` or `.pfx` but may be anything you choose.

# PEM / PKCS#12 Conversions
1. Commands to create a `.pfx/.p12` file using OpenSSL pkcs12
2. Commands to export elements of PKCS#12
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 1. Create a .pfx/.p12 file using OpenSSL pkcs12
All the following commands works for both **ECC** and **RSA** certificates and keys.  

Use this command if you want to create a PKCS#12 file with the private key and the complete certificate chain of trust:
```shell
cat server-key.pem int-crt.pem ca-crt.pem > chain-crt.pem
openssl pkcs12 -export -inkey server-key.pem -in server-crt.pem -CAfile chain-crt.pem -chain -out domain.p12
```

Use this command if you want to create a PKCS#12 file with the certificate and private key:
```shell
openssl pkcs12 -export -inkey server-key.pem -in server-crt.pem -out server.p12
```
>You will be prompt for a password to encrypt the file.  

### View PKCS#12 file
Use this command to view the content of a PKCS#12-encoded file:
```shell
openssl pkcs12 -info -noenc -in domain.p12
```
>The switch `-noenc` prints the private key in clear.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 2. Export elements of PKCS#12
This section lists the commands to export some or all elements from a `.p12` encoded file. I listed the commands for both **ECC** and **RSA** cryptography in every section.

To save the output to a file, use `-out OUTFILE.key` parameter. You can encrypt the private key by removing the `-noenc` flag from the command.

To export only the private key from a PKCS#12 file to PEM format, use this command:
```shell
openssl pkcs12 -noenc -nocerts -in domain.p12
```

To export only the certificates from a PKCS#12 file to PEM format, use this command:
```shell
openssl pkcs12 -nokeys -in domain.p12
```

To export all of the information from a PKCS#12 file to PEM format, use this command:
```shell
openssl pkcs12 -noenc -in domain.p12
```

To export only the CA certificates from a PKCS#12 file to PEM format, use this command:
```shell
openssl pkcs12 -nodes -nokeys -cacerts -in domain.p12
```

To export only the client certificate(s) from a PKCS#12 file to PEM format, use this command:
```shell
openssl pkcs12 -noenc -nokeys -clcerts -in domain.p12
```

Run the following command to import only a certificate into a new keystore:
```shell
openssl pkcs12 -export -nokeys -in server-crt.pem -out server-crt.p12
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
# License
Distributed under the MIT License. See [MIT license](/LICENSE) for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
# Contact
Daniel Della-Noce - [Linkedin](https://www.linkedin.com/in/daniel-della-noce-2176b622/) - daniel@isociel.com

Project Link: [https://github.com/ddella/OpenSSL](https://github.com/ddella/OpenSSL)
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
# Acknowledgments
* [www.ssl.com](https://www.ssl.com/guide/pem-der-crt-and-cer-x-509-encodings-and-conversions/)
* [www.digicert.com](https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<p align="right">(<a href="README.md">back to Certificate format section</a>)</p>
