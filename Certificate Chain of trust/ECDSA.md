# Verify a certificate signature (Elliptic Curve only)
This explains how to verify the signature of a certificate. The prerequisites are:
1. The certificate we whish to verify
2. The issuer certificate (we need it's public key)

## Extract the signature value from the certificate
I didn't find a cleaner way to get the signature from a certificate. I print the whole X.509 certificate and grab the last portion of it, which is the signature. That works for RSA and ECC.
```shell
openssl x509 -in server-crt.pem -text -noout -certopt ca_default -certopt no_validity -certopt no_serial -certopt no_subject -certopt no_extensions -certopt no_signame | grep -v 'Signature Algorithm' | sed 's/Signature Value//g' | tr -d '[:space:] [:punct:]' > signature.hex
```
The output is the signature, in hexadecimal, without any punctuation and line feeds. It's a plain text file of ascii characters representing a large hexadecimal number.
>```
>68f449bf50 ... d3b561160a1d0b4a01a80ff79
>```
## Extract the signature algorithm from the certificate
I don't use it for now but it will be usefull in future version of my script. That works for RSA and ECC.
```shell
openssl x509 -in server-crt.pem -text -noout -certopt ca_default -certopt no_validity -certopt no_serial -certopt no_subject -certopt no_extensions -certopt no_signame | grep 'Signature Algorithm:' | sed 's/Signature Algorithm://g' | tr -d '[:space:]'
```
The output should look like this:
>```
>ecdsa-with-SHA256
>```
## Convert the hexadecimal signature and dump it as a binary file
At this point, the signature is in hexadecimal and encrypted with the private key of the issuer. The following command creates a binary file with the certificate signature. It just converts ascii character, representing an hexadecimal value, in binary format.
```shell
xxd -r -p signature.hex > sig_encrypted.bin
```
>**Note**:A raw ECDSA signature is comprised of two integers **`R`** and **`S`**.  
**Optional:** Use the following command to see the two integers.
```shell
openssl asn1parse -inform der -in sig_encrypted.bin
```
>```
>  0:d=0  hl=2 l=  69 cons: SEQUENCE
>  2:d=1  hl=2 l=  33 prim: INTEGER     :AE8F52BB1EE48924B4123296AA846F74C76962BCBDFCFB40D697937E48FC31CB
> 37:d=1  hl=2 l=  32 prim: INTEGER     :2FC45B0436B2C5F74A44229B7F350CC1855C668CC7E10393EBFC4D005C6B2FEF
>```
## Extract the public key from issuer certificate
The signature of the end-user certificate has been produced with the private key of the issuer, so the public key is needed to verify it. Use this command to extract the public key from a certificate:
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
## Extract the body part of certificate without the signature part
This command extract the body part of the end-user certificate without the signature.
```shell
openssl asn1parse -in server-crt.pem -noout -strparse 4 -out cert_body.bin
```
The output creates a file `cert_body.bin` that is the binary version of the end-user certificate, without the signature hash.
## Verify the signature
Use this command to verify the signature:
```shell
openssl dgst -sha256 -verify int-pubkey.pem -signature sig_encrypted.bin cert_body.bin
```
It uses the signature that we extracted from the end-user certificate, the certificate without the signature and the public key of the issuer.  
If the end-user certificate was signed by the issuer, the output will be:
>```
>Verified OK
>```
If the end-user certificate wasn't signed by the issuer, the output will be:
>```
>Verified failure
>```
You could also verify the shell variable `$?`, if you're in a script.
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to main page_](README.md)  
[_< back to root_](../../../)
