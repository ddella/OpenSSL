<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# PEM / PKCS#8 Conversions
1. Commands to convert from `PEM` to `PKCS#8` format
2. Commands to convert from `PKCS#8` to `PEM` format
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 1. PEM to PKCS#8
This section lists the commands to convert from a `.pem` encoded format to a `.pk8` encoded format. The commands are identical for both **ECC** and **RSA** cryptography.

### Convert private key
Use this command if you want to add PEM certificates `*-crt.pem` to a PKCS#7 file `*-domain.p7b`:
```shell
openssl pkcs8 -in ECC-server-key.pem -topk8 -nocrypt -out ECC-server-key.pk8
openssl pkcs8 -in RSA-server-key.pem -topk8 -nocrypt -out RSA-server-key.pk8
```
>**Note**: You can use one or more `-certfile` options to specify which certificates to add to the PKCS#7 file.  

### Private key PEM and PKCS#8 file
In case of RSA private key, both files are identical:
```shell
cmp RSA-server-key.pem RSA-server-key.pk8
```

In case of ECC private key, files are different:
```shell
cmp ECC-server-key.pem ECC-server-key.pk8
```
    ECC-server-key.pem ECC-server-key.pk8 differ: char 12, line 1

```shell
cat ECC-server-key.pk8
```
    -----BEGIN PRIVATE KEY-----
    MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgzT9hR5IREbBwu3AP
    9yhL+sGUbwk8o1j+j9RKP5wobZ2hRANCAAQIXUuZuhsW+DJzdmkTekRuJSk5ooiA
    7jNpBNH/hnc7B0rxqfHsJpeWfjBNrluj8gxUCE2uCWp7Yq5g1Kpx1Yq3
    -----END PRIVATE KEY-----

```shell
cat ECC-server-key.pem
```
    -----BEGIN EC PARAMETERS-----
    BggqhkjOPQMBBw==
    -----END EC PARAMETERS-----
    -----BEGIN EC PRIVATE KEY-----
    MHcCAQEEIM0/YUeSERGwcLtwD/coS/rBlG8JPKNY/o/USj+cKG2doAoGCCqGSM49
    AwEHoUQDQgAECF1LmbobFvgyc3ZpE3pEbiUpOaKIgO4zaQTR/4Z3OwdK8anx7CaX
    ln4wTa5bo/IMVAhNrglqe2KuYNSqcdWKtw==
    -----END EC PRIVATE KEY-----

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
