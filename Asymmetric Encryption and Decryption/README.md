# Cryptographic Message Syntax
The Cryptographic Message Syntax (CMS) is the IETF's standard for cryptographically protected messages. It can be used to digitally sign, digest, authenticate or encrypt any form of digital data.

CMS uses public key encryption based on RSA or Elliptic Curve Cryptography (ECC) algorithms and stores the encrypted versions of the random key in the CMS object. The random key is used to encrypt the actual CMS payload with a symmetric algorithm and store it in the CMS.

Encryption is done with a public key and requires the corresponding private key to decrypt the data. You need to pass the certificate when encrypting with Cryptographic Message Syntax (CMS). 

Both `openssl cms` and `openssl smime` utilities can be used for digitally signing, verifying, encrypted, and decrypting files. The `openssl cms` utility supports newer methods of encryption like ECC. This is why we’ll use `openssl cms` for this example.

## Encryption and decryption with CMS
In this example we will explore the commands to encrypt and decrypt a file with asymmetric key of type **RSA** and **ECC**.  

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
openssl pkey -pubout -in rsa-key.pem -out rsa-public-key.pem
```

Use this command to extract the ECC public key from the ECC private key:
```shell
openssl ec -pubout -in ecc-key.pem -out ecc-public-key.pem
```
## 3. Encrypt a file with OpenSSL CMS
Use this command, or any of your choice, to generate a dummy file for encryption and decryption:
```shell
< /dev/urandom head -c 1048576 > file.bin
```
This creates a 10MB binray file with random data.  

Use those commands to encrypt with an **RSA** and **ECC** public key. The `openssl cms` command just requires the certificate of the receipient of the message. It will extract the public key from it.  
```shell
openssl cms -encrypt -binary -outform DER -in file.bin -aes256 -out file.bin.enc.ecc ecc-crt.pem
openssl cms -encrypt -binary -outform DER -in file.bin -aes256 -out file.bin.enc.rsa rsa-crt.pem
```

You have two new files that are the encrypted version of `file.bin`.
>```
>-rw-r--r--  1 username  staff  1048576  1 Jan 00:00 file.bin
>-rw-r--r--  1 username  staff  1048957  1 Jan 00:00 file.bin.enc.ecc
>-rw-r--r--  1 username  staff  1049075  1 Jan 00:00 file.bin.enc.rsa
>```
## 4. View encrypted file structure
Let's take a look at the header of an encrypted file. The command `openssl cms -cmsout ...` prints the header of **ECC** or **RSA** encrypted file. As stated in the introduction, the algorithm stores the encrypted versions of the random key in the CMS object.  

Use this command to view the CMS structure of an **ECC** the encrypted file:
```shell
openssl cms -inform DER -cmsout -print -in file.bin.enc.ecc | grep -B 100 'encryptedContent:'
```

Output:
>```
>CMS_ContentInfo: 
>  contentType: pkcs7-envelopedData (1.2.840.113549.1.7.3)
>  d.envelopedData: 
>    version: 2
>    originatorInfo: <ABSENT>
>    recipientInfos:
>      d.kari: 
>        version: 3
>        d.originatorKey: 
>          algorithm: 
>            algorithm: id-ecPublicKey (1.2.840.10045.2.1)
>            parameter: <ABSENT>
>          publicKey:  (0 unused bits)
>            0000 - 04 6f 42 9c 8a 30 52 b0-51 18 32 77 5f 76   .oB..0R.Q.2w_v
>            000e - 7f 9a d9 88 77 7f 13 39-79 62 91 d9 c5 bc   ....w..9yb....
>            001c - 8a e1 a5 6c e5 64 19 ec-98 6c c5 27 79 50   ...l.d...l.'yP
>            002a - 9e 76 7d d7 17 c5 1c 90-bd 33 a0 d4 8c 6a   .v}......3...j
>            0038 - 96 6c e2 fc ad a5 34 b8-54                  .l....4.T
>        ukm: <ABSENT>
>        keyEncryptionAlgorithm: 
>          algorithm: dhSinglePass-stdDH-sha1kdf-scheme (1.3.133.16.840.63.0.2)
>          parameter: SEQUENCE:
>    0:d=0  hl=2 l=  11 cons: SEQUENCE          
>    2:d=1  hl=2 l=   9 prim:  OBJECT            :id-aes256-wrap
>        recipientEncryptedKeys:
>            d.issuerAndSerialNumber: 
>              issuer: C=CA, ST=QC, L=Montreal, O=ecc, OU=IT, CN=ecc.com
>              serialNumber: 0x290AEA79EFB4FA15BD49064353A197D0E4188224
>            encryptedKey: 
>              0000 - 03 02 de c4 ca 81 8f bf-76 78 db cc d7 8b   ........vx....
>              000e - 73 a7 3e 90 7d b3 90 84-52 94 73 f1 5d 2d   s.>.}...R.s.]-
>              001c - 30 82 0b b6 97 f0 51 d6-8d 6b fc 01         0.....Q..k..
>    encryptedContentInfo: 
>      contentType: pkcs7-data (1.2.840.113549.1.7.1)
>      contentEncryptionAlgorithm: 
>        algorithm: aes-256-cbc (2.16.840.1.101.3.4.1.42)
>        parameter: OCTET STRING:
>          0000 - 8b 16 13 b9 a9 08 0f eb-c7 c7 25 1f e5 c8 42   ..........%...B
>          000f - 9e                                             .
>      encryptedContent:
>```

Use this command to view the CMS structure of an **RSA** the encrypted file:
```shell
openssl cms -inform DER -cmsout -print -in file.bin.enc.rsa | grep -B 100 'encryptedContent:'
```

Output:
>```
>CMS_ContentInfo: 
>  contentType: pkcs7-envelopedData (1.2.840.113549.1.7.3)
>  d.envelopedData: 
>    version: 0
>    originatorInfo: <ABSENT>
>    recipientInfos:
>      d.ktri: 
>        version: 0
>        d.issuerAndSerialNumber: 
>          issuer: C=CA, ST=QC, L=Montreal, O=rsa, OU=IT, CN=rsa.com
>          serialNumber: 0x691AFFBEE17C2C7750EA8855E09B600493808A08
>        keyEncryptionAlgorithm: 
>          algorithm: rsaEncryption (1.2.840.113549.1.1.1)
>          parameter: NULL
>        encryptedKey: 
>          0000 - 24 f3 8e 6d 42 3e 2d a6-ba eb a6 f2 5d df 7d   $..mB>-.....].}
>          000f - 81 af bb 00 1d fb 1d 89-a3 47 1f 5b bc 28 c3   .........G.[.(.
>          001e - 7e 4d d9 56 a5 86 a5 6d-a1 00 24 27 d4 97 b1   ~M.V...m..$'...
>          002d - 1a f7 c6 61 55 ab 1e d9-a0 1e 01 b9 86 27 1b   ...aU........'.
>          003c - 4d fe 6f f8 fa 35 4b 11-8f b3 2a 6c 5e 7c 43   M.o..5K...*l^|C
>          004b - e9 b4 00 4e 22 b4 7c 83-b8 bc d8 ce 1f ff e8   ...N".|........
>          005a - d4 b8 c0 ea 5d 45 be fd-c3 03 fb 1e 1b cd eb   ....]E.........
>          0069 - 6a c6 bc 9d 32 5d 5e 84-09 4e 58 4e 6b a1 cc   j...2]^..NXNk..
>          0078 - 6d ed 5f 5c fe 5b 7f 9b-2e a2 c8 f7 48 12 d4   m._\.[......H..
>          0087 - 04 98 ab 19 1f 9c 53 f8-bb 0f 42 b7 71 0f 7d   ......S...B.q.}
>          0096 - 78 c6 f4 c1 fb 37 b6 fd-9d 37 ab 0e 2b 97 6b   x....7...7..+.k
>          00a5 - 01 46 4b d4 69 37 9a b6-8c e2 a2 ec 59 ae 3c   .FK.i7......Y.<
>          00b4 - 54 f2 68 f9 e5 37 8c 14-db 86 b8 ab c4 60 92   T.h..7.......`.
>          00c3 - 63 25 90 08 ec 17 92 ff-a2 dd 62 84 f3 80 ba   c%........b....
>          00d2 - d6 37 aa 71 b9 55 e1 92-81 7c 76 de 73 55 cd   .7.q.U...|v.sU.
>          00e1 - 52 e7 3f 5b e5 86 09 ca-a1 81 ba c1 07 e0 19   R.?[...........
>          00f0 - f4 7e f9 2c 76 ae 6f 30-2d 9f 4e 4a f1 7b 87   .~.,v.o0-.NJ.{.
>          00ff - 70                                             p
>    encryptedContentInfo: 
>      contentType: pkcs7-data (1.2.840.113549.1.7.1)
>      contentEncryptionAlgorithm: 
>        algorithm: aes-256-cbc (2.16.840.1.101.3.4.1.42)
>        parameter: OCTET STRING:
>          0000 - 0a b0 83 a0 a4 fb 2d 0d-d6 ff 99 ef 7f 13 03   ......-........
>          000f - 92                                             .
>      encryptedContent: 
>```

# 5. Decrypt a file with OpenSSL CMS
Use this command to decrypt using ECC and RSA private key:
```shell
openssl cms -decrypt -in file.bin.enc.ecc -binary -inform DEM -inkey ecc-key.pem -out ecc-file.bin
openssl cms -decrypt -in file.bin.enc.rsa -binary -inform DEM -inkey rsa-key.pem -out rsa-file.bin
```
>Files `ecc-key.pem` and `rsa-key.pem` contains the respective private key.

The files `ecc-file.bin` and `rsa-file.bin` should be a copy of the original file `file.bin`. We'll do a simple digest on all three files and make sure all three values are identical.  

```
% openssl dgst -sha256 file.bin
SHA2-256(file.bin)= d619296b4620a168d87a221487f2b001d604eedf78355ba8a97963816c99cd10

% openssl dgst -sha256 rsa-file.bin
HA2-256(rsa-file.bin)= d619296b4620a168d87a221487f2b001d604eedf78355ba8a97963816c99cd10

% openssl dgst -sha256 ecc-file.bin
SHA2-256(ecc-file.bin)= d619296b4620a168d87a221487f2b001d604eedf78355ba8a97963816c99cd10
```
## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Cryptographic-Message-Syntax)  
[_< back to root_](../../../)
