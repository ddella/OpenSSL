<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# ECC Private and Public Keys
This section shows the different [OpenSSL](https://www.openssl.org/) commands to generate/view/check an Elliptic Curve Cryptographic **(ECC)** private and public keys.

## Private and Public key with ECC keys
Both **ECC** and **RSA** generate a pair of private/public key mathematically tied together to allow two parties to communicate securely. The main advantage of ECC is that a 256-bit key in ECC offers about the same security as a 3072-bit key using RSA.

The commands used in this section generate unencrypted private key in PEM PKCS#8 format. The PKCS#8 format is the most interoperable format.

>`ECC Public Key`: Is the staring and ending points on a curve  
>`ECC Private Key`: Is the number of hops from start to finish  

![Alt text](/images/ecc-priv-pub-key.jpg "ECC Private and Public key")

## Generate an ECC Private Key
This section is about generating a private/public ECC key pair.

>**Note**: It's important to note that we never generate a public key but rather a private key that includes the public key. This is valid for both `ECC` and `RSA`.

Use this command to prints a list of all curve 'short names':
```shell
openssl ecparam -list_curves
```

Use this command to generate an **ECC** private key `ECC-private-key.pem`:
```shell
openssl genpkey -algorithm EC \
-pkeyopt ec_paramgen_curve:prime256v1 \
-pkeyopt ec_param_enc:named_curve \
-out ECC-private-key.pem
```
>An ECC Private Key starts with:
>```
>-----BEGIN PRIVATE KEY-----
>-----END PRIVATE KEY-----
>```


>Use `-prime256v1` for X9.62/SECG curve over a 256-bit prime field  
>Use `-secp384r1` for NIST/SECG curve over a 384-bit prime field  
>Use `-secp521r1` for NIST/SECG curve over a 521-bit prime field  

## Extract ECC Public Key
Use this command to extract the corresponding public key from the private key:
```shell
openssl pkey -pubout -in ECC-private-key.pem -out ECC-public-key.pem
```

Use this command to extract the public and private key in hex format:
```shell
openssl pkey -noout -text -in ECC-private-key.pem
```

Use this command to get the following private key details:
1. The public key
2. The private key
3. The algorithm used to generate the keys

```shell
openssl pkey -text -noout -in ECC-private-key.pem
```
>Replace `-text` by `-text_pub` to get only the public key (modulus and public exponent)  
>This command works with both RSA and ECC private keys  

Use this command to check key consistency:
```shell
openssl pkey -noout -check -in ECC-private-key.pem
```
>If valid, will return `EC Key valid` else `unable to load Key`.  
>If inside a shell script, you could test for the variable `$?`. A value of `0` indicates a valid key and a value of `1` indicates an invalid key.

    % openssl pkey -noout -check -in valid-ECC-private-key.pem
    read EC key
    EC Key valid.
    % echo $?
    0

    % openssl pkey -noout -check -in invalid-ECC-private-key.pem
    read EC key
    Could not read private key from ECC-private-key.pem
    unable to load Key
    % echo $?                                         
    1

## Encrypt/Decrypt an ECC Private Key
Does only works with **ECC** Private Key.

This takes an plain text ECC Private Key `ECC-private-key.pem` and outputs an encrypted version of it in the file `ECC-private-key.pem.enc`:
```shell
openssl pkey -in ECC-private-key.pem -aes256 -out ECC-private-key.pem.enc
```
>An ECC encrypted private key starts with:  
>```
>-----BEGIN ENCRYPTED PRIVATE KEY-----
>-----END ENCRYPTED PRIVATE KEY-----
>```

This takes an encrypted private key `ECC-private-key.pem.enc` and outputs a decrypted version of it `ECC-private-key.pem`:
```shell
openssl pkey -in ECC-private-key.pem.enc -out ECC-private-key.pem
```

## Verify an ECC Private Key matches a Public Key
We know that an ECC Private key contains the Public Key. To verify that both keys are related, just hash them and if the value is the same, they **are** related.  
If you have the public and private key in a separate files, hash both public key and make sure the results matches.  
```shell
openssl pkey -in ECC-private-key.pem -pubout | openssl dgst -sha256 -r | cut -d' ' -f1
openssl sha256 -r ECC-public-key.pem | cut -d' ' -f1
```
>`MD5` could have been used instead of `SHA256`  
***
## Verify an ECC Private Key matches a Certificate and a CSR
To verify that a private key matches a certificate and it's CSR, just hash the public key of all three and if the value is the same, they **are** related.  
```shell
openssl pkey -in ECC-private-key.pem -pubout | openssl dgst -sha256 -r | cut -d' ' -f1
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
