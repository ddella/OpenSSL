<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# Certificate Formats
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PEM
**PEM** (Privacy Enhanced Mail) is the most common format for X.509 certificates, CSRs, and cryptographic keys. A **PEM** file is a text file containing one or more items in Base64 ASCII encoding, each with plain-text headers and footers.

    -----BEGIN CERTIFICATE-----
    -----END CERTIFICATE-----

    -----BEGIN CERTIFICATE REQUEST-----
    -----END CERTIFICATE REQUEST-----

    -----BEGIN EC PRIVATE KEY-----
    -----END EC PRIVATE KEY-----

    -----BEGIN PUBLIC KEY-----
    -----END PUBLIC KEY-----

A single **PEM** file could contain an end-entity certificate, a private key, or multiple certificates forming a complete chain of trust. **PEM** files are usually seen with the extensions `.crt`, `.pem`, `.cer`, and `.key` for private keys. You could give any extension to a **PEM** file. A PEM encoded certificate file is really a **DER** encoded certificate with Base64 algorithm.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## DER
**DER** (Distinguished Encoding Rules) is a data object encoding schema that can be used to encode certificate objects into binary files. It is used for encoding X.509 certificates and private keys. **DER** files are most commonly seen in Java contexts. DER-encoded files are usually found with the extensions `.der` and `.cer`.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PKSC#7
**PKCS#7** (also known as P7B) is a container format for digital certificates that is most often found in Windows and Java server contexts, and usually has the extension .`p7b`. **PKCS#7** files are never used to store private keys.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PKCS#12
The **PKCS#12** format is a container format that stores both the certificate and the private key. This format is useful for moving a certificate and it’s corresponding private key to a new system. **PKCS#12** files use either the `.pfx` or `.p12` file extension.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

# PEM Conversions
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PEM to DER
This section lists the commands to convert from a `.pem` encoded format to a `.der` encoded format. I listed the commands for both **ECC** and **RSA** cryptography in every section.

### Convert certificate
Use this command to convert a PEM-encoded **certificate** `*-crt.pem` to a DER-encoded **certificate** `*-crt.der`:
```shell
openssl x509 -in ECC-server-crt.pem -outform der -out ECC-server-crt.der
openssl x509 -in RSA-server-crt.pem -outform der -out RSA-server-crt.der 
```

### Convert private key
Use this command to convert a PEM-encoded **private key** `*-server-key.pem` to a DER-encoded **private key** `*-server-key.der`:
```shell
openssl ec -inform PEM -in ECC-server-key.pem -outform DER -out ECC-server-key.der
openssl rsa -inform PEM -in RSA-server-key.pem -outform DER -out RSA-server-key.der
```

### Convert public key
Use this command to convert a PEM-encoded **public key** `*-public-key.pem` to a DER-encoded **public key** `*-public-key.der`:
```shell
openssl ec -pubin -inform PEM -in ECC-public-key.pem -outform DER -out ECC-public-key.der
openssl rsa -pubin -inform PEM -in RSA-server-key.pem -outform DER -out RSA-server-key.der
```

### View DER file
Use this command to view the content of an RSA DER-encoded **certificate**, **private key** and **public key** file:
```shell
openssl x509 -text -noout -inform der -in ECC-server-crt.der
openssl ec -text -noout -inform der -in ECC-server-key.der
openssl ec -text -noout -pubin -inform der -in ECC-public-key.der
```

Use this command to view the content of an RSA DER-encoded **certificate**, **private key** and **public key** file:
```shell
openssl x509 -text -noout -inform der -in RSA-server-crt.der
openssl rsa -text -noout -inform der -in RSA-server-key.der
openssl rsa -text -noout -pubin -inform der -in RSA-public-key.der
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PEM to PKCS#7
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PEM to PKCS#12
<p align="right">(<a href="#readme-top">back to top</a>)</p>

# PKCS#7 Conversions
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PKCS#7 to PEM
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PKCS#7 to DER
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PKCS#7 to PKCS#12
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
# License
Distributed under the MIT License. See `LICENSE.txt` for more information.
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
<p align="right">(<a href="../">back to root</a>)</p>
