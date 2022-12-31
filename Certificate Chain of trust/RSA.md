# Verify a certificate signature RSA only
This explains how to verify the signature of a certificate signed with RSA. The prerequisites are:
1. The certificate we whish to verify
2. The issuer certificate (we need it's public key)

The best way to understand the signature verification process is to do it manually, aka the hard way 😀
## Extract the signature value from the certificate
I didn't find a cleaner way to get the signature from a certificate. I print the whole X.509 certificate and grab the last portion of it, which is the signature. That works for RSA and ECC.
```shell
openssl x509 -in server-crt.pem -text -noout -certopt ca_default -certopt no_validity -certopt no_serial -certopt no_subject -certopt no_extensions -certopt no_signame | grep -v 'Signature Algorithm' | sed 's/Signature Value//g' | tr -d '[:space:] [:punct:]' > signature.hex
```
The output is the signature, in hexadecimal, without any punctuation and line feeds. It's a plain text file of ascii characters representing a large hexadecimal number.
>```
>68f449bf50 ... d3b561160a1d0b4a01a80ff79
>```
**Optional**: Since the goal is to verify the signature of certificate, let's say we want a bad signature but something that would make sense. A signature that OpenSSL can read.
Use this command to generate a bad signature out of a certificate. Its the same command as above but with the `-badsig` option:
```shell
openssl x509 -in server-crt.pem -badsig -text -noout -certopt ca_default -certopt no_validity -certopt no_serial -certopt no_subject -certopt no_extensions -certopt no_signame | grep -v 'Signature Algorithm' | sed 's/Signature Value//g' | tr -d '[:space:] [:punct:]' > bad.hex
```
## (Optional) Extract the signature algorithm from the certificate
I don't use it for now but it will be usefull in future version of my script. That works for RSA and ECC.
```shell
openssl x509 -in server-crt.pem -text -noout -certopt ca_default -certopt no_validity -certopt no_serial -certopt no_subject -certopt no_extensions -certopt no_signame | grep 'Signature Algorithm:' | sed 's/Signature Algorithm://g' | tr -d '[:space:]' > sig_algo.txt
```
The output should look like this:
>```
>sha256WithRSAEncryption
>```
## Convert the hexadecimal signature and dump it as a binary file
At this point the signature is in hexadecimal and encrypted with the private key of the issuer. The following command creates a binary file with the encrypted certificate signature. It just convert ascii character, representing an hexadecimal value, in binary format.
```shell
xxd -r -p signature.hex > sig_encrypted.bin
```
## Extract the public key from issuer certificate
The signature of the end-user certificate has been encrypted with the private key of the issuer, so the public key is needed to decrypt it.
```shell
openssl x509 -in int-crt.pem -noout -pubkey -out int-pubkey.pem
```
This will create a `PEM` file with the public key that looks like this:
>```
>-----BEGIN PUBLIC KEY-----
>MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAowiUKapbpqHprklG2jje
>...
>JWDluXDg19ZZqRNyhZ7qydMCAwEAAQ==
>-----END PUBLIC KEY-----
>```
## Decrypt the RSA signature from a binary encrypted signature
It takes the issuer public key to decrypt the signature from previous step. The output is an X.690 binary file with the decrypted certificate signature.
```shell
openssl pkeyutl -verifyrecover -pubin -inkey int-pubkey.pem -in sig_encrypted.bin -out sig_decrypted_x690.bin
```
Use this commande to view what's inside the file `sig_decrypted_x690.bin`:
```shell
openssl asn1parse -inform der -in sig_decrypted_x690.bin
```
The output is the decoded version of the X.690 file. The signature is at offset 17:
>```
>  0:d=0  hl=2 l=  49 cons: SEQUENCE          
>  2:d=1  hl=2 l=  13 cons: SEQUENCE          
>  4:d=2  hl=2 l=   9 prim: OBJECT         :sha256
>15:d=2  hl=2 l=   0 prim: NULL              
>17:d=1  hl=2 l=  32 prim: OCTET STRING   [HEX DUMP]>:89C49CF762F2133FEA6D9495111B0BF7F899B846A55618061FA0AFB906D34B6C
>```
Use this command to extract the decrypted signature hash value from the X.690 file and save it to a binary file:
```shell
openssl asn1parse -inform der -in sig_decrypted_x690.bin -offset 17 | sed 's/.*\[HEX DUMP\]://' | xxd -r -p > sig_decrypted.bin
```

At this point we:
1. Downloaded the end-user certificate
2. Downloaded the issuer certificate
3. Extracted the issuer public key from its certificate
4. Decrypted the signature from the end-user certificate with the public key from the issuer

We have the decrypted signature of the end-user certificate. Lets see if this signature equals the one we calculate.
## Extract the body part of certificate without RSA signature part
This command extract the body part of the end-user certificate without the signature. We will use the body part to do our own calculation on the signature and compare it to the decrypted one we calculated earlier. If they match, then the issuer signed the end-user certificate.
```shell
openssl asn1parse -in server-crt.pem -noout -strparse 4 -out cert_body.bin
```
The output creates a bin file `cert_body.bin` that is the binary version of the server certificate without the signature hash.
## Calculate the hash of certificate body
```shell
openssl dgst -sha256 -binary -out sig_calculated.bin cert_body.bin
```
The output is the binary representation of the `sha256` of the certificate. We just calculated our own hash from the certificate received from the server.
## Lets compare the files
Lets compare the file `sig_decrypted.bin` and `sig_calculated.bin`. If they match, issuer signed the end-user certificate. They should both represent the binary value of the hash signature of the end-user certificate.
```shell
cmp -bl sig_calculated.bin sig_decrypted.bin
```
No output means files are identical. You could also verify the shell variable `$?` if you're in a script.
## Files created
| **File**               | **Description**                                                 |
|------------------------|-----------------------------------------------------------------|
| int-crt.pem            | Issuer X.509 certificate                                        |
| server-crt.pem         | End-user X.509 certificate                                      |
| cert_body.bin          | The end-user certificate in binary without the signature        |
| int-pubkey.pem         | Public key of intermediate certificate in PEM                   |
| sig_calculated.bin     | Hash of the end-user certificate body                           |
| sig_decrypted.bin      | The decrypted hash of the end-user certificate in binary format |
| sig_decrypted_x690.bin | The decrypted hash of the end-user certificate in X.690 format  |
| sig_encrypted.bin      | The encrypted hash of the end-user certificate                  |
| signature.hex          | The encrypted hash in hexadecimal                               |
## Easier way to do with OpenSSL
There's an easier way to do the verification by letting `openssl` do the work for us with this command:
```shell
openssl dgst -sha256 -verify int-pubkey.pem -signature sig_encrypted.bin cert_body.bin
```
## Shell Script to automate the verification (RSA only)
I made a very simple script to automate the verification. It takes an end-user certificte, an issuer certificate and verify if the issuer really signed the end-user certificate. You can find it [here](https://gist.github.com/ddella/bff877bc4929c5872bf06e9ddcf8ca4c). Remember this is for educational purposes **ONLY**.
## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Verify-a-certificate-signature-for-RSA-only)  
[_< back to Certificate Chain of trust page_](README.md)  
[_<< back to root_](../../../)
