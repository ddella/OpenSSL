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
This created a 10MB binray file with random data.  

Use this command to encrypt with an RSA or ECC public key:  
```shell
openssl cms -encrypt -binary -outform DER -in file.bin -aes-256-cbc -out file.bin.ecc ecc-crt.pem
openssl cms -encrypt -binary -outform DER -in file.bin -aes-256-cbc -out file.bin.rsa rsa-crt.pem
```

You have two new files that are the encrypted version of `file.bin`.
>```
>-rw-r--r--  1 username  staff  1048576  1 Jan 00:00 file.bin
>-rw-r--r--  1 username  staff  1048957  1 Jan 00:00 file.bin.ecc
>-rw-r--r--  1 username  staff  1049075  1 Jan 00:00 file.bin.rsa
>```
## 4. View encrypted file structure
Use this command to view the ASN.1 structure of each the encrypted file:
```shell
openssl asn1parse -inform der -in file.bin.ecc
```

Output:
>```
>0:d=0  hl=5 l=1048952 cons: SEQUENCE          
>5:d=1  hl=2 l=   9 prim: OBJECT            :pkcs7-envelopedData
>16:d=1  hl=5 l=1048936 cons: cont [ 0 ]        
>21:d=2  hl=5 l=1048931 cons: SEQUENCE          
>26:d=3  hl=2 l=   1 prim: INTEGER           :02
>29:d=3  hl=4 l= 280 cons: SET               
>33:d=4  hl=4 l= 276 cons: cont [ 1 ]        
>37:d=5  hl=2 l=   1 prim: INTEGER           :03
>40:d=5  hl=2 l=  81 cons: cont [ 0 ]        
>42:d=6  hl=2 l=  79 cons: cont [ 1 ]        
>44:d=7  hl=2 l=   9 cons: SEQUENCE          
>46:d=8  hl=2 l=   7 prim: OBJECT            :id-ecPublicKey
>55:d=7  hl=2 l=  66 prim: BIT STRING        
>123:d=5  hl=2 l=  24 cons: SEQUENCE          
>125:d=6  hl=2 l=   9 prim: OBJECT            :dhSinglePass-stdDH-sha1kdf-scheme
>136:d=6  hl=2 l=  11 cons: SEQUENCE          
>138:d=7  hl=2 l=   9 prim: OBJECT            :id-aes256-wrap
>149:d=5  hl=3 l= 161 cons: SEQUENCE          
>152:d=6  hl=3 l= 158 cons: SEQUENCE          
>155:d=7  hl=2 l= 114 cons: SEQUENCE          
>157:d=8  hl=2 l=  90 cons: SEQUENCE          
>159:d=9  hl=2 l=  11 cons: SET               
>161:d=10 hl=2 l=   9 cons: SEQUENCE          
>163:d=11 hl=2 l=   3 prim: OBJECT            :countryName
>168:d=11 hl=2 l=   2 prim: PRINTABLESTRING   :CA
>172:d=9  hl=2 l=  11 cons: SET               
>174:d=10 hl=2 l=   9 cons: SEQUENCE          
>176:d=11 hl=2 l=   3 prim: OBJECT            :stateOrProvinceName
>181:d=11 hl=2 l=   2 prim: UTF8STRING        :QC
>185:d=9  hl=2 l=  17 cons: SET               
>187:d=10 hl=2 l=  15 cons: SEQUENCE          
>189:d=11 hl=2 l=   3 prim: OBJECT            :localityName
>194:d=11 hl=2 l=   8 prim: UTF8STRING        :Montreal
>204:d=9  hl=2 l=  12 cons: SET               
>206:d=10 hl=2 l=  10 cons: SEQUENCE          
>208:d=11 hl=2 l=   3 prim: OBJECT            :organizationName
>213:d=11 hl=2 l=   3 prim: UTF8STRING        :ecc
>218:d=9  hl=2 l=  11 cons: SET               
>220:d=10 hl=2 l=   9 cons: SEQUENCE          
>222:d=11 hl=2 l=   3 prim: OBJECT            :organizationalUnitName
>227:d=11 hl=2 l=   2 prim: UTF8STRING        :IT
>231:d=9  hl=2 l=  16 cons: SET               
>233:d=10 hl=2 l=  14 cons: SEQUENCE          
>235:d=11 hl=2 l=   3 prim: OBJECT            :commonName
>240:d=11 hl=2 l=   7 prim: UTF8STRING        :ecc.com
>249:d=8  hl=2 l=  20 prim: INTEGER           :290AEA79EFB4FA15BD49064353A197D0E4188224
>271:d=7  hl=2 l=  40 prim: OCTET STRING      [HEX DUMP]:D63FEE3332C1083F58768BE4C35B82C191416E740C55E5415E2C873186DAB35FEF5A0B821B50CD49
>313:d=3  hl=5 l=1048639 cons: SEQUENCE          
>318:d=4  hl=2 l=   9 prim: OBJECT            :pkcs7-data
>329:d=4  hl=2 l=  29 cons: SEQUENCE          
>331:d=5  hl=2 l=   9 prim: OBJECT            :aes-256-cbc
>342:d=5  hl=2 l=  16 prim: OCTET STRING      [HEX DUMP]:1348084D85B7D46EE55700331D78FDCE
>360:d=4  hl=5 l=1048592 prim: cont [ 0 ]        
>```

```shell
openssl asn1parse -inform der -in file.bin.rsa
```

# 5. Decrypt a file with OpenSSL SMIME/CMS
Use this command to decrypt with using RSA and ECC private key:
```shell
openssl cms -decrypt -in file.bin.ecc -binary -inform DEM -inkey ecc-key.pem -out ecc-file.bin
openssl cms -decrypt -in file.bin.rsa -binary -inform DEM -inkey rsa-key.pem -out rsa-file.bin
```
>Files `ecc-key.pem` and `rsa-key.pem` contains the respective private key.

The files `ecc-file.bin` and `rsa-file.bin` should be identaical to the original file `file.bin` 
```
% md5 file.bin
MD5 (file.bin) = 273fc8fbebe5c8b2f9fc9efa635579f6

% md5 rsa-file.bin
MD5 (rsa-file.bin) = 273fc8fbebe5c8b2f9fc9efa635579f6

% md5 ecc-file.bin
MD5 (ecc-file.bin) = 273fc8fbebe5c8b2f9fc9efa635579f6
```
## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Cryptographic-Message-Syntax-(CMS))  
[_< back to root_](../../../)
