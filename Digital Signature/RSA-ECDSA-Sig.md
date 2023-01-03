# RSA and ECDSA signature with OpenSSL
The following commands work with RSA or ECDSA signature.   

![Alt text](/images/rsa-sig.jpg "RSA signature")
## 1. Generate an RSA or ECC private key
Use this command to generate an RSA private key `private-key.pem`:
```shell
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private-key.pem
```
**OR**
Use this command to generate an ECC private key `private-key.pem`:
```shell
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem
```
## 2. Extract the public key, from the private key
Use this command to extract the RSA public key from the private key:
```shell
openssl pkey -pubout -in private-key.pem -out public-key.pem
```
**OR**
Use this command to extract the ECC public key from the private key:
```shell
openssl ec -in private-key.pem -pubout -out public-key.pem
```
## 4. Create, sign and encrypt the hash
This section works for both RSA or ECDSA signarure.  

Use this command to hash the file, sign the hash and encrypt the signature with the signer's private key:
```shell
openssl dgst -sha256 -sign private-key.pem -out encrypted.sig test.txt
```
**Optional, you can skip to the next section**
Use this command to decrypt the signature by using the signer's public key:
```shell
openssl pkeyutl -verifyrecover -pubin -inkey public-key.pem -in encrypted.sig -out decrypted.sig
```
Use this commande to view the decrypted signature:
```shell
openssl asn1parse -inform der -in decrypted.sig
```
>Output for RSA:
>```
>  0:d=0  hl=2 l=  49 cons: SEQUENCE          
>  2:d=1  hl=2 l=  13 cons: SEQUENCE          
>  4:d=2  hl=2 l=   9 prim: OBJECT        :sha256
>15:d=2  hl=2 l=   0 prim: NULL              
>17:d=1  hl=2 l=  32 prim: OCTET STRING  [HEX DUMP]:C42175B85AABF162D62F397409289DB930136B541B4BE0A9BE7D9FF21AB75728
>```

>Output for ECDSA:
>```
>  0:d=0  hl=2 l=  70 cons: SEQUENCE          
>  2:d=1  hl=2 l=  33 prim: INTEGER     :86A665B1393B230EF7B3D03226C25392D2958F5F7B50AC266F9882DFFF4D7BC7
>37:d=1  hl=2 l=  33 prim: INTEGER     :9BF6689E4E8CEF98268AE0255A9FD06411446C8E03064C378DCE99154368BC55
>```
## 6. Modify the source data and verify the signature
Now lets modify the data, `test.txt`, and check the signature against the modified file.  
Use this command to verify the signature against the original file:
```shell
openssl dgst -sha256 -verify public-key.pem -signature encrypted.sig test.txt
```
Output:
>```
>Verified OK
>```
I just added a blank line at the end of the file `test.txt` and now the verification fails.
```shell
openssl dgst -sha256 -verify public-key.pem -signature encrypted.sig test.txt
```
Output:
>```
>Verification failure
>```
## License
This project is licensed under the [MIT license](/LICENSE).  
Icons from Flaticon were used: [flaticon](https://www.flaticon.com/free-icons/document)

[_^ back to top of page_](#RSA-and-ECDSA-signature-with-OpenSSL)  
[_< back to Digital Signature_](README.md)  
[_<< back to root_](../../../)
