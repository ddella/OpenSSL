# ECDSA signature with OpenSSL
**ECDSA** stands for *Elliptic Curve Digital Signature Algorithm*. It creates a digital signature in order to verify the authenticity and integrety of a message. A hash of the message is calculated. This hash is signed with the private key of the sender of the data.  The receiver use the public key to get the hash and calculate is own hash against the received data. If both hash match, then the data has not been modified in transit. Cryptographers agree that it is almost impossible to forge an **ECDSA** signature. **ECDSA** does not encrypt your data, it protects against tampering with your data.  

A **hash** functions transform *variable* length of data to a *fixed-length* value and is known to be collision-resistant and irreversible (a one-way function).
![Alt text](/images/ecdsa-sig.jpg "ECDSA signature")
## Basic idea with Elliptic Curve Cryptography
There's a mathematical equation which draws a curve on a graph. You choose a random point on that curve and consider that your point of origin. Then you generate a random number, this is your private key, you do some magical mathematical equation using with the pair (random number, point of origin) and you get a second point on the curve, that’s your public key.  
[to learn more on ECC](https://www.instructables.com/Understanding-how-ECDSA-protects-your-data/)
## ECDSA signature with OpenSSL
In this section I'll walk through the process to perform ECDSA signature on a bogus file that we call `data`. That will work on any type of data, either text or binary file. Following are the steps to generate a signature file:  
1. Generate an ECC private key
2. Extract the public key, from the private key
3. Generate a hash
4. Create a signature using the private key and the hash
5. Verify the signature
6. Modify the source data and verify the signature  
## 1. Generate an ECC private key
Use this command to generate an elliptic curve private key `private-key.pem`:
```shell
openssl ecparam -name prime256v1 -genkey -noout -out private-key.pem
```
>The file `private-key.pem` looks like:
>```
>-----BEGIN EC PRIVATE KEY-----
> [...]
>-----END EC PRIVATE KEY-----
>```
## 2. Extract the public key, from the private key
Use this command to extract the ECC public key from the private key:
```shell
openssl ec -in private-key.pem -pubout -out public-key.pem
```
>The file `public-key.pem` looks like:
>```
>-----BEGIN PUBLIC KEY-----
> [...]
>-----END PUBLIC KEY-----
>```
## 3. Generate a hash
I used the file `test.txt` to simulate my precious data. It's a simple text file. It could have been a binary file.
>```
>This is the first line.
>This is a test with ECDSA.
>This is the third and last line.
>```
Use this command to generate a hash:
```shell
openssl dgst -sha256 -binary -out hash-sha256.bin test.txt
```
**Note**: The size of the file `hash-sha256.bin` is 32 bytes or 256 bits 😉
## 4. Sign the hash.
We are signing a hash value, not the file or data. The **hash** function transformed our file of *variable* length to a *fixed-length* value of 256 bit.
```shell
openssl pkeyutl -sign -inkey private-key.pem -in hash-sha256.bin -out ecdsa.sig
```
**Optional**: Use this command to view the **ECDSA** signature:
```shell
openssl asn1parse -inform der -in ecdsa.sig
```
EC signature consists of two numbers **`R`** and **`S`**. This is how the ASN.1 structure looks like:
>```
>  0:d=0  hl=2 l=  70 cons: SEQUENCE          
>  2:d=1  hl=2 l=  33 prim: INTEGER     :86A665B1393B230EF7B3D03226C25392D2958F5F7B50AC266F9882DFFF4D7BC7
>37:d=1  hl=2 l=  33 prim: INTEGER     :9BF6689E4E8CEF98268AE0255A9FD06411446C8E03064C378DCE99154368BC55
>```
>**Note**: I know the two integers are 33 octets instead of the 32 octets (256-bit) expected. That's because they have their most significant bit is set to `1` so it would be consider a negative value, but it can't be so it's padded with `0x00`. When the math is done, the padding is removed.

Use this command to view the binary file in hexadecimal:
```shell
xxd -p ecdsa.sig
```
See in yellow, each interger has been padded with `0x00`. If it had not been padded, the first binary digit of the integer would start with a  `1` hence a negative value.
![Alt text](/images/padded-octet.jpg "Padded Octet")
## 5. Verify the signature
Use this command to verify that the signature correspond to the hash:
```shell
openssl pkeyutl -verify -pubin -in hash-sha256.bin -inkey public-key.pem -sigfile ecdsa.sig
```
Output:
>```
>Signature Verified Successfully
>```
## 6. Modify the source data and verify the signature
In the preceding step we verified the signature against our hash. We could modify the file and redo the last command and it will still succeed, unless we redo the whole procedure. Now lets modify the data, `test.txt`, and check the signature against the modified file.  
Use this command to verify the signature against the original file:
```shell
openssl dgst -sha256 -verify public-key.pem -signature ecdsa.sig test.txt
```
Output:
>```
>Verified OK
>```
I just added a blank line at the end of the file `test.txt` and now the verification fails.
```shell
openssl dgst -sha256 -verify public-key.pem -signature ecdsa.sig test.txt
```
Output:
>```
>Verification failure
>```
## License
This project is licensed under the [MIT license](/LICENSE).  
Icons from Flaticon were used: [flaticon](https://www.flaticon.com/free-icons/document)

[_^ back to top of page_](#ECDSA-signature-with-OpenSSL)  
[_< back to Digital Signature_](README.md)  
[_<< back to root_](../../../)
