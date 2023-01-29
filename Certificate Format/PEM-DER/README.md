<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

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
