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
**PKCS#7** (also known as P7B) is a container format for digital certificates that is most often found in Windows and Java server contexts, and usually has the extension .`p7b`. **PKCS#7** files are never used to store private keys. A `p7b` can be a text file containing one or more items in Base64 ASCII encoding, each with plain-text headers and footers.

    -----BEGIN PKCS7-----
    -----END PKCS7-----

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## PKCS#12
The **PKCS#12** format is a container format that stores both the certificate and the private key. This format is useful for moving a certificate and it’s corresponding private key to a new system. **PKCS#12** files use either the `.pfx` or `.p12` file extension.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

# PEM - DER Conversion
This section lists the commands to convert from a `.pem` to `.der` format and vice-versa. I listed the commands for both **ECC** and **RSA** cryptography.
<p align="left"><a href="PEM-DER.md">PEM to DER section</a></p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

# PEM - PKCS#7 Conversion
<p align="left"><a href="PEM-PKCS7.md">PEM to PKCS#7 section</a></p>
<p align="right">(<a href="#readme-top">back to top</a>)</p>

# PEM - PKCS#12 Conversion
<p align="left"><a href="PEM-PKCS12.md">PEM to PKCS#12 section</a></p>
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
