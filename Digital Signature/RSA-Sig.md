# RSA signature with OpenSSL
**RSA Signarure** stands for *Rivest–Shamir–Adleman Signature Algorithm*. It creates a digital signature in order to verify the authenticity and integrity of a message. **RSA Signarure** does not encrypt your data, it protects against tampering with your data.  

![Alt text](/images/rsa-sig.jpg "RSA signature")
## 1. Generate an RSA private key
Use this command to generate an RSA private key `private-key.pem`:
```shell
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private-key.pem
```
>The file `private-key.pem` looks like:
>```
>-----BEGIN PRIVATE KEY-----
> [...]
>-----END PRIVATE KEY-----
>```
## 2. Extract the public key, from the private key
Use this command to extract the RSA public key from the private key:
```shell
openssl pkey -pubout -in private-key.pem -out public-key.pem
```
>The file `public-key.pem` looks like:
>```
>-----BEGIN PUBLIC KEY-----
> [...]
>-----END PUBLIC KEY-----
>```
## 3. Generate a hash (optional)
This section is optional. The command in the next section will take care of creating the hash but you won't have a file with only the hash value.  

I used the file `test.txt` to simulate my precious data. It's a simple text file. It could have been a binary file. The **hash** function transformed our file of *variable* length into a *fixed-length* value of 256 bit.
>```
>This is the first line.
>This is a test with RSA.
>This is the third and last line.
>```
Use this command to generate a hash:
```shell
openssl dgst -sha256 -binary -out hash-sha256.bin test.txt
```
**Note**: The size of the file `hash-sha256.bin` is 32 bytes or 256 bits 😉
>-rw-r--r--  1 username  staff  32  1 Jan 00:00 hash-sha256.bin
## 4. Create, sign and encrypt the hash
Use this command to hash the file, sign the hash and encrypt the signature with the signer's private key:
```shell
openssl dgst -sha256 -sign private-key.pem -out rsa-encrypted.sig test.txt
```
>An **RSA** signature is *kind of encrypted*. Saying that the hash has been encrypted with a private key is wrong.

**Optional, you can skip to the next section**

Use this command to decrypt the signature by using the signer's public key:
```shell
openssl pkeyutl -verifyrecover -pubin -inkey public-key.pem -in rsa-encrypted.sig -out rsa-decrypted.sig
```
Use this commande to view the decrypted RSA signature:
```shell
openssl asn1parse -inform der -in rsa-decrypted.sig
```
>Output:
>```
>  0:d=0  hl=2 l=  49 cons: SEQUENCE          
>  2:d=1  hl=2 l=  13 cons: SEQUENCE          
>  4:d=2  hl=2 l=   9 prim: OBJECT        :sha256
>15:d=2  hl=2 l=   0 prim: NULL              
>17:d=1  hl=2 l=  32 prim: OCTET STRING  [HEX DUMP]:C42175B85AABF162D62F397409289DB930136B541B4BE0A9BE7D9FF21AB75728
>```
Use this commande to view the binary data of the hash we calculated in the step above:
```shell
xxd -p hash-sha256.bin
```
You can see that the value of the file `hash-sha256.bin` correspond to the last field of the file `rsa-decrypted.sig`.
>Output:
>```
>c42175b85aabf162d62f397409289db930136b541b4be0a9be7d9ff21ab7
>5728
>```
## 5. Verify the signature
Use this command to verify the signature of file `test.txt` with the public of signer:
```shell
openssl dgst -sha256 -verify public-key.pem -signature rsa-encrypted.sig test.txt
```
Output:
>```
>Verified OK
>```
**Optional**
If you decrypted the signarure in the step above, you should have a file `rsa-decrypted.sig`. Extract the hash value and compare it to the original hash.
Use this command to extract the hash value from the ASN1 file `rsa-decrypted.sig`:
```shell
openssl asn1parse -inform der -in rsa-decrypted.sig -offset 17 | sed 's/.*\[HEX DUMP\]://' | xxd -r -p > new-hash.bin
```
Use this command to compare both files:
```shell
cmp new-hash.bin hash-sha256.bin
```
>No output means both files are **identical**
## 6. Modify the source data and verify the signature
Now lets modify the data, `test.txt`, and check the signature against the modified file.  
Use this command to verify the signature against the original file:
```shell
openssl dgst -sha256 -verify public-key.pem -signature rsa-encrypted.sig test.txt
```
Output:
>```
>Verified OK
>```
I just added a blank line at the end of the file `test.txt` and now the verification fails.
```shell
openssl dgst -sha256 -verify public-key.pem -signature rsa-encrypted.sig test.txt
```
Output:
>```
>Verification failure
>```
## License
This project is licensed under the [MIT license](/LICENSE).  
Icons from Flaticon were used: [flaticon](https://www.flaticon.com/free-icons/document)

[_^ back to top of page_](#RSA-signature-with-OpenSSL)  
[_< back to Digital Signature_](README.md)  
[_<< back to root_](../../../)
