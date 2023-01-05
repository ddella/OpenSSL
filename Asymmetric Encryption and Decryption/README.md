# Cryptographic Message Syntax (CMS)
The Cryptographic Message Syntax (CMS) is the IETF's standard for cryptographically protected messages. It can be used to digitally sign, digest, authenticate or encrypt any form of digital data.

CMS uses public key encryption based on RSA or Elliptic Curve Cryptography (ECC) algorithms and stores the encrypted versions of the random key in the CMS object. The random key is used to encrypt the actual CMS payload with a symmetric algorithm and store it in the CMS.

Encryption is done with a public key and requires the corresponding private key to decrypt the data. You need to pass the certificate when encrypting with Cryptographic Message Syntax (CMS). 

Both `openssl cms` and `openssl smime` utilities can be used for digitally signing, verifying, encrypted, and decrypting files. The `openssl cms` utility supports newer methods of encryption like ECC. This is why we’ll use `openssl cms` for this example.

## 1. Generate an RSA or ECC self signed certificate
We will use a self signed certificate throughout this example. I've made two scripts of my Gist to generate the certificates. Each script creates three files. You will onkly need the certificate `-crt.pem` and the private key `-key.pem`.  

- [ECC self signed certificate](https://gist.github.com/ddella/f6954409d2090908f6fec1fc3280d9d1)
- [RSA self signed certificate](https://gist.github.com/ddella/d04a0a0a155b2237b67ad8e0b2302017)

Let's try both RSA and ECC. I ran both scripts:  

```shell
./self_signed_ecc.sh ecc
```

```shell
./self_signed_rsa.sh rsa
```

I got the following files:  

>```
>-rw-r--r--   1 username  staff  1302  1 Jan 00:00 ecc-crt.pem
>-rw-r--r--   1 username  staff   952  1 Jan 00:00 ecc-csr.pem
>-rw-------   1 username  staff   294  1 Jan 00:00 ecc-key.pem
>-rw-r--r--   1 username  staff  1842  1 Jan 00:00 rsa-crt.pem
>-rw-r--r--   1 username  staff  1488  1 Jan 00:00 rsa-csr.pem
>-rw-------   1 username  staff  1708  1 Jan 00:00 rsa-key.pem
>```
## 2. Extract the public key from the private key (OPTIONAL)
You can extract the public key from the private key. This step is **optional** and not needed for now.  

Use this command to extract the RSA public key from the RSA private key:
```shell
openssl pkey -pubout -in private-key.pem -out public-key.pem
```

Use this command to extract the ECC public key from the ECC private key:
```shell
openssl ec -pubout -in private-key.pem -out public-key.pem
```
## 3. Encrypt a file with OpenSSL CMS
Use this command to encrypt with an RSA or ECC public key:  

```shell
openssl cms -encrypt -binary -outform DER -in file.bin -aes256 -out file.bin.enc 1-crt.pem
```
## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Cryptographic-Message-Syntax-(CMS))  
[_< back to root_](../../../)
