<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# RSA Private and Public Key
This section shows the different [OpenSSL](https://www.openssl.org/) commands to generate, view and check a Rivest, Shamir, & Adleman **(RSA)** private and public key.

The commands used in this section generate unencrypted private key in PEM PKCS#8 format. The PKCS#8 format is the most interoperable format.

## Private and Public key with RSA keys
Both **ECC** and **RSA** generate a pair of private and public key mathematically tied together to allow two parties to communicate securely. The main advantage of ECC is that a 256-bit key in ECC offers about the same security as a 3072-bit key using RSA.

>`RSA Public Key`: Is the **Modulus** and **publicExponent**  
>`RSA Private Key`: Is the **privateExponent**   

![Alt text](/images/rsa-priv-pub-key.jpg "RSA Private and Public key")
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Generate an RSA Private Key
The openssl `genpkey` utility has superseded the `genrsa` utility. It is recommended to use `genpkey` going forward.

Use this command to create an unencrypted 2048-bit private key `RSA-private-key.pem`:
```shell
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out RSA-private-key.pem
```
>A PKCS#8 Private Key, both RSA and ECC, starts with:
>```
>-----BEGIN PRIVATE KEY-----
>-----END PRIVATE KEY-----
>```

Use this command to create a password-protected 2048-bit private key `encrypted-key.pem`. The command generate a private key and encrypts the file in a single command:
```shell
openssl genpkey -aes256 -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out encrypted-key.pem
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Extract the Public Key from an RSA Private Key
The **Public Key** is composed of the modulus and the public exponent.

Use this command to extract the corresponding public key from the private key:
```shell
openssl pkey -pubout -in RSA-private-key.pem -out RSA-public-key.pem
```

> This gives the Public key in PEM format

The following two commands gives the same results and outputs the public key to `stdout`.  

This gives the modulus and the public exponent in hex format from the **Private** key PEM file
```shell
openssl pkey -text_pub -noout -in RSA-private-key.pem
```

This gives the modulus and the public exponent in hex format from the **Public** Key PEM file
```shell
openssl pkey -pubin -text -noout -in RSA-public-key.pem
```

Use this command to view the key modulus (this is RSA specific,as there's no modulus for ECC):
```shell
openssl rsa -modulus -noout -in RSA-private-key.pem
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Verify an RSA Private Key
Use this command to verify that a private key `RSA-private-key.pem` is valid. It will only output `RSA key ok`or `Could not read private key from RSA-private-key.pem`:
```shell
openssl pkey -check -noout -in RSA-private-key.pem
```

>If valid, will return `RSA key ok` else `Could not read private key from RSA-private-key.pem`.  
>If inside a shell script, you could test for the variable `$?`. A value of `0` indicates a valid key and a value of `1` indicates an invalid key.

    % openssl pkey -check -noout -in valid-RSA-private-key.pem
    RSA key ok
    % echo $?
    0

    % openssl pkey -check -noout -in invalid-RSA-private-key.pem
    Could not read private key from RSA-private-key.pem
    % echo $?                                         
    1
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Get detailed information on RSA Private and Public Key
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

Use this command to get the following private key details:
1. The modulus (public key)
2. The public exponent (public key)
3. The private exponent (private key)
4. The two large prime numbers that were used to generate the modulus
5. Other numbers to help improve RSA performance

```shell
openssl pkey -text -noout -in RSA-private-key.pem
```
>Replace `-text` by `-text_pub` to get only the public key (modulus and public exponent)  
>This command works with both RSA and ECC private keys  

```shell
openssl pkey -noout -text -in RSA-private-key.pem
```
>This command works only with RSA private keys  
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Encrypt/Decrypt an RSA Private Key
Does only works with **RSA** Private Key.

This takes an plain text private key `RSA-private-key.pem` and outputs an encrypted version of it in the file `RSA-private-key.pem.enc`:
```shell
openssl pkey -aes256 -in RSA-private-key.pem -out RSA-private-key.pem.enc
```
>An RSA encrypted private key starts with:  
>```
>-----BEGIN ENCRYPTED PRIVATE KEY-----
> [...]
>-----END ENCRYPTED PRIVATE KEY-----
>```

This takes an encrypted private key `RSA-private-key.pem.enc` and outputs a decrypted version of it `RSA-private-key.pem`:
```shell
openssl pkey -in RSA-private-key.pem.enc -out RSA-private-key.pem
```
>Use the `-passout file:mypass` parameter to read the password from a file, when encrypting the key  
>Use the `-passin file:mypass` parameter to read the password from a file, when decrypting the key  
>The first line of `mypass` is the password  
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Verify an RSA Private Key matches a Public Key
We know that an RSA Private key contains the Public Key. To verify that both keys are related, just hash them and if the value is the same, they **are** related.  
If you have the public and private key in a separate files, hash both public key and make sure the results matches.  
```shell
openssl pkey -pubout -in RSA-private-key.pem | openssl dgst -sha256 -r | cut -d' ' -f1
openssl sha256 -r RSA-public-key.pem | cut -d' ' -f1
```
>`MD5` could have been used instead of `SHA256`  
>The public key is a key pair of the public exponent `e` and the modulus `n` and is present as follow: `(e,n)`
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Verify an RSA Private Key matches a Certificate and a CSR
To verify that a private key matches a certificate and it's CSR, just hash the public key of all three and if the value is the same, they **are** related.  
```shell
openssl pkey -pubout -in RSA-private-key.pem | openssl dgst -sha256 -r | cut -d' ' -f1
openssl x509 -in server-crt.pem -pubkey -noout | openssl dgst -sha256 -r | cut -d' ' -f1
openssl req -in server-csr.pem -pubkey -noout | openssl dgst -sha256 -r | cut -d' ' -f1
```
>`MD5` could have been used instead of `SHA256` to make the numbers smaller.  
>The public key, included in the private key, the server certificate and the CSR, is the **same** public key.

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
* [OpenSSL](https://www.openssl.org/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<p align="right">(<a href="../">back to root</a>)</p>
