<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# PEM / DER Conversions
1. Commands to convert from `PEM` to `DER` format
2. Commands to convert from `DER` to `PEM` format
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 1. PEM to DER
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
openssl ec -in ECC-server-key.pem -outform DER -out ECC-server-key.der
openssl rsa -in RSA-server-key.pem -outform DER -out RSA-server-key.der
```

### Convert public key
Use this command to convert a PEM-encoded **public key** `*-public-key.pem` to a DER-encoded **public key** `*-public-key.der`:
```shell
openssl ec -pubin -in ECC-public-key.pem -outform DER -out ECC-public-key.der
openssl rsa -pubin -in RSA-public-key.pem -outform DER -out RSA-public-key.der
```

### View DER file
Use this command to view the content of an ECC DER-encoded **certificate**, **private key** and **public key** file:
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

## 2. DER to PEM
This section lists the commands to convert from a `.der` encoded format to a `.pem` encoded format. I listed the commands for both **ECC** and **RSA** cryptography in every section.

### Convert certificate
Use this command to convert a DER-encoded **certificate** `*-crt.der` to a PEM-encoded **certificate** `*-crt.pem`:
```shell
openssl x509 -inform der -in ECC-server-crt.der -out ECC-server-crt.pem
openssl x509 -inform der -in RSA-server-crt.der -out RSA-server-crt.pem
```

### Convert private key
Use this command to convert a DER-encoded **private key** `*-server-key.der` to a PEM-encoded **private key** `*-server-key.pem`:
```shell
openssl ec -inform der -in ECC-server-key.der -out ECC-server-key.pem
openssl rsa -inform der -in RSA-server-key.der -out RSA-server-key.pem
```

### Convert public key
Use this command to convert a DER-encoded **public key** `*-public-key.der` to a PEM-encoded **public key** `*-public-key.pem`:
```shell
openssl ec -pubin -inform DER -in ECC-public-key.der -out ECC-public-key.pem
openssl rsa -pubin -inform DER -in RSA-public-key.der -out RSA-public-key.pem
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
