# OpenSSL Private and Public Keys
## Private and Public key fields with RSA keys
Only the **Modulus**, **publicExponent** and **privateExponent** are required for asymmetric encryption and decryption using RSA. The other numbers are helpful for improving the performance of the RSA algorithm.

| Term            | Definition                                                                                                                                                                                                                                       |
|-----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Modulus         | The result of multiplying p (prime1) and q (prime2) is called n. Its length, expressed in bits, is the key length.                                                                                                                               |
| publicExponent  | The public exponent used for encryption and decryption is called e. The public key consists of the modulus (n) and the public exponent (e). For big primes, everybody's using e=65537                                                            |
| privateExponent | The private exponent used for encryption and decryption is called d. The private key consists of the modulus (n) and the private exponent (d). Pick this so d*e=1 mod (p-1)*(q-1). You should shred p and q after picking d, and keep d secret.  |
| prime1          | The first of two prime numbers that are multiplied together to produce the modulus is called p.                                                                                                                                                  |
| Prime2          | The second of two prime numbers that are multiplied together to produce the modulus is called q.                                                                                                                                                 |
| exponent1       | A result stored to improve RSA performance. Refer to the Chinese Remainder Theorem. Calculated from d mod (p – 1).                                                                                                                               |
| exponent2       | A result stored to improve RSA performance. Refer to the Chinese Remainder Theorem. Calculated from d mod (q – 1).                                                                                                                               |
| Coefficient     | A result stored to improve RSA performance. Refer to the Chinese Remainder Theorem. Calculated from (inverse of q) mod p.                                                                                                                        |
| Public Key      | The public key consists of the Modulus (n) and the public exponent (e). Those two numbers are published.                                                                                                                                         |
| Private Key     | The private key consists of the private exponent (d). For the purist, the modulus is also part of the private key.                                                                                                                                                                                           |


![Alt text](/images/rsa-priv-pub-key.jpg "RSA Private and Public key")

The openssl `genpkey` utility has superseded the `genrsa` utility. It is recommended to use `genpkey` going forward.

***
***
## Generate an RSA Private Key
Use this command to create an unencrypted 2048-bit private key `private-key.pem`:
```shell
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private-key.pem
```
>An RSA Private Key starts with:
>```
>-----BEGIN PRIVATE KEY-----
> [...]
>-----END PRIVATE KEY-----
>```

Use this command to create a password-protected 2048-bit private key `encrypted-key.pem`:
```shell
openssl genpkey -aes256 -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out encrypted-key.pem
```

***
## Verify an RSA Private Key
Use this command to verify that a private key `private-key.pem` is valid. It will only output `RSA key ok`or `Could not read private key from private-key.pem`:
```shell
openssl rsa -check -noout -in private-key.pem
```

Use this command to get the following private key details:
1. The modulus (public key)
2. The public exponent (public key)
3. The private exponent (private key)
4. The two large prime numbers that were used to generate the modulus
5. Other numbers to help improve RSA performance

```shell
openssl pkey -text -noout -in private-key.pem
```
>Replace `-text` by `-text_pub` to get only the public key (modulus and public exponent)  
>This command works with both RSA and ECC private keys  

```shell
openssl rsa -noout -text -in private-key.pem
```
>This command works only with RSA private keys  

***
## Extract the Public Key from an RSA Private Key
The **Public Key** is composed of the modulus and the public exponent.

Use this command to extract the corresponding public key from the private key:
```shell
openssl pkey -pubout -in private-key.pem -out public-key.pem
```
> This gives the Public key in PEM format

The following two commands gives the same output.
```shell
openssl pkey -text_pub -noout -in private-key.pem
```
> This gives the modulus and the public exponent in hex format from the **Private** Key PEM file

Use this command to view the public key details:
```shell
openssl pkey -pubin -text -noout -in public-key.pem
```
> This gives the modulus and the public exponent in hex format from the **Public** Key PEM file

Use this command to view the key modulus:
```shell
openssl rsa -modulus -noout -in private-key.pem
```
>The modulus is the same for both the private and the public key.

***
***
## Encrypt/Decrypt an RSA Private Key
Does only works with **RSA** Private Key.

This takes an plain text private key `private-key.pem` and outputs an encrypted version of it in the file `private-key.pem.enc`:
```shell
openssl rsa -aes256 -in private-key.pem -out private-key.pem.enc
```
>An RSA encrypted private key starts with:  
>```
>-----BEGIN ENCRYPTED PRIVATE KEY-----
> [...]
>-----END ENCRYPTED PRIVATE KEY-----
>```


This takes an encrypted private key `private-key.pem.enc` and outputs a decrypted version of it `private-key.pem`:
```shell
openssl rsa -in private-key.pem.enc -out private-key.pem
```
>Use the `-passout file:mypass` parameter to read the password from a file, when encrypting the key  
>Use the `-passin file:mypass` parameter to read the password from a file, when decrypting the key  
>The first line of `mypass` is the password  

***
***
## Verify an RSA Private Key matches a Public Key
We know that an RSA Private key contains the Public Key. To verify that both keys are related, just hash them and if the value is the same, they **are** related.  
If you have the public and private key in a separate files, hash both public key and make sure the results matches.  
```shell
openssl pkey -pubout -in private-key.pem | openssl dgst -sha256 -r | cut -d' ' -f1
openssl sha256 -r public-key.pem | cut -d' ' -f1
```
>`MD5` could have been used instead of `SHA256`  
>The public key is a key pair of the public exponent `e` and the modulus `n` and is present as follow: `(e,n)`
***
## Verify an RSA Private Key matches a Certificate and a CSR
To verify that a private key matches a certificate and it's CSR, just hash the public key of all three and if the value is the same, they **are** related.  
```shell
openssl pkey -pubout -in private-key.pem | openssl dgst -sha256 -r | cut -d' ' -f1
openssl x509 -in server-crt.pem -pubkey -noout | openssl dgst -sha256 -r | cut -d' ' -f1
openssl req -in server-csr.pem -pubkey -noout | openssl dgst -sha256 -r | cut -d' ' -f1
```
>`MD5` could have been used instead of `SHA256`  
>The public key is included in the private key, the server certificate and the CSR and is the **same**.
***
***
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#OpenSSL-Private-and-Public-Keys)  
[_< back to root_](../../../)
