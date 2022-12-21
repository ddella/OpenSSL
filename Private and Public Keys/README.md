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
| Private Key     | The private key consists of the private exponent (d).*                                                                                                                                                                                           |

*For the purist, the modulus is also part of the private key.

The openssl `genpkey` utility has superseded the `genrsa` utility. It is recommended to use `genpkey` going forward.

## Private and Public key with EC keys

ECC and RSA both generate a pair of public/private key mathematically tied together to allow two parties to communicate securely. The main advantage of ECC is that a 256-bit key in ECC offers about the same security as a 3072-bit key using RSA.

>`ECC Public Key`: Is the staring and ending point on a curve   
>`ECC Private Key`: Is the number of hops from start to finish  

## Generate an RSA Private Key
Use this command to create an unencrypted 2048-bit private key `private-key.pem`:
```shell
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private-key.pem
```
>An RSA Private Key starts with: ```-----BEGIN PRIVATE KEY-----```

Use this command to create a password-protected 2048-bit private key `encrypted-key.pem`:
```shell
openssl genpkey -aes256 -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out encrypted-key.pem
```

## Verify an RSA Private Key
Use this command to verify that a private key `private-key.pem` is valid. It will only output `RSA key ok`or `Could not read private key from private-key.pem`:
```shell
openssl rsa -check -noout -in private-key.pem
```

Use this command to get the private key details. This command gives:
1. The modulus (public key)
2. The public exponent (public key)
3. The private exponent (private key)
4. The two large prime numbers that were used to generate the modulus
5. Other numbers to help improve RSA performance
```shell
openssl pkey -text -noout -in private-key.pem
```
>Replace `-text` by `-text_pub` to get only the modulus and the public exponent:

## Extract the Public Key from an RSA Private Key
The **Public Key** is the modulus and the public exponent.

Use this command to extract the corresponding public key from the private key:
```shell
openssl pkey -pubout -in private-key.pem -out public-key.pem
```

Use this command to view the public key details:
```shell
openssl pkey -pubin -text -noout -in public-key.pem
```

Use this command to view the private key modulus. This command is useless since the modulus of the private key is the same as the public key:
```shell
openssl rsa -modulus -noout -in private.key.pem
```

## Generate an Elliptic Curve Private Key
Use this command to prints a list of all curve 'short names':
```shell
openssl ecparam -list_curves
```

Use this command to generate a private key from elliptic curve `private-key.pem`:
```shell
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem
```
>An ECC Private Key starts with: ```-----BEGIN EC PRIVATE KEY-----```

>Use `-noout`  parameter to remove the information parameters used to generate the key from  the file  
>Use `-prime256v1` for X9.62/SECG curve over a 256-bit prime field  
>Use `-secp384r1` for NIST/SECG curve over a 384-bit prime field  
>Use `-secp521r1` for NIST/SECG curve over a 521-bit prime field  

Use this command to extract the corresponding public key from the private key:
```shell
openssl ec -in private-key.pem -pubout -out public-key.pem
```

Use this command to extract the public and private key in hex format:
```shell
openssl ec -in private-key.pem -noout -text
```

Use this command to check key consistency:
```shell
openssl ec -in private-key.pem -noout -check
```
>If valid, will return `EC Key valid` else `unable to load Key`.

## Encrypt/Decrypt an RSA Private Key
Does only works with **RSA** Private Key.

This takes an plain text private key `private-key.pem` and outputs an encrypted version of it in the file `private-key.pem.enc`:
```shell
openssl rsa -aes256 -in private-key.pem -out private-key.pem.enc
```
>An encrypted private key starts with: ```-----BEGIN ENCRYPTED PRIVATE KEY-----```

This takes an encrypted private key `private-key.pem.enc` and outputs a decrypted version of it `private-key.pem`:
```shell
openssl rsa -in private-key.pem.enc -out private-key.pem
```
>Use the `-passout file:mypass` parameter to read the password from a file, when encrypting the key  
>Use the `-passin file:mypass` parameter to read the password from a file, when decrypting the key  
>The first line of `mypass` is the password  

## Encrypt/Decrypt an ECC Private Key
Does only works with **ECC** Private Key.

This takes an plain text ECC Private Key `private-key.pem` and outputs an encrypted version of it in the file `private-key.pem.enc`:
```shell
openssl ec -in private-key.pem -aes256 -out private-key.pem.enc
```
>An encrypted private key starts with:  
>```
>-----BEGIN EC PRIVATE KEY-----  
>Proc-Type: 4,ENCRYPTED  
>DEK-Info: AES-256-CBC,4AB00EF87803C74D6645B3543B174734
>```

This takes an encrypted private key `private-key.pem.enc` and outputs a decrypted version of it `private-key.pem`:
```shell
openssl ec -in private-key.pem.enc -out private-key.pem
```
