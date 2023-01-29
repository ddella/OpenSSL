<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# PEM / PKCS#7 Conversions
1. Commands to convert from `PEM` to `PKCS#7` format
2. Commands to convert from `PKCS#7` to `PEM` format
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 1. PEM to PKCS#7
This section lists the commands to convert from a `.pem` encoded format to a `.p7b` encoded format. The commands are identical for both **ECC** and **RSA** cryptography.

### Convert certificate
Use this command if you want to add PEM certificates `*-crt.pem` to a PKCS#7 file `*-domain.p7b`:
```shell
openssl crl2pkcs7 -nocrl -certfile ECC-server-crt.pem -certfile ECC-int-crt.pem -out ECC-domain-crt.p7b
openssl crl2pkcs7 -nocrl -certfile RSA-server-crt.pem -certfile RSA-int-crt.pem -out RSA-domain-crt.p7b
```
>Add the option `-outform DER` to save the `PKCS#7` file in DER-format  

>**Note**: You can use one or more `-certfile` options to specify which certificates to add to the PKCS#7 file.  

They are usually `ASCII` files which can contain server, intermediate and CA certificates.

### View PKCS#7 file
Use this command to view the content of an ECC PKCS#7-encoded **certificate** file:
```shell
openssl pkcs7 -noout -print -in ECC-domain-crt.p7b
openssl pkcs7 -noout -print -in RSA-domain-crt.p7b
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 2. PKCS#7 to PEM
This section lists the commands to convert from a `.p7b` encoded format to a `.pem` encoded format. I listed the commands for both **ECC** and **RSA** cryptography in every section.

### Convert certificate
Use this command to convert a DER-encoded **certificate** `*-crt.p7b` to a PEM-encoded **certificate** `*-crt.pem`:
```shell
openssl pkcs7 -print_certs -in ECC-domain-crt.p7b -out ECC-domain-crt.pem
openssl pkcs7 -print_certs -in RSA-domain-crt.p7b -out RSA-domain-crt.pem
```
>Add the option `-inform DER` to read a DER-format `PKCS#7` file
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
<p align="right">(<a href="README.md">back to Certificate format section</a>)</p>
