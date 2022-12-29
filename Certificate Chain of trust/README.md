# Certificate Chain of trust
**Certificate Chain** or **Chain of Trust** is made up of an ordered list of certificates that start from the end-user certificate and terminate with the Certificate Authority (CA) certificate. It may contain one or more intermediate certificate.s in between. The **Certificate Chain** enables the receiver to verify that the sender and all CA's are trustworthy. 

The Intermediate Certificate.s is any certificate.s that sits between the end-user certificate and the Root Certificate. The Intermediate Certificate is the signer/issuer of the end-user Certificate. The Root CA Certificate is the signer/issuer of the Intermediate Certificate. If the Intermediate Certificate is not installed on the server,  where the end-user certificate is installed, it may prevent some browsers from trusting the end-user certificate.

If your end-user certificate is to be trusted, its signature has to be traceable back to its root CA. In the certificate chain, every certificate is signed by the entity that is identified by the next certified along the chain, except the RootCA which is a self-signed certificate.

The **Certificate Chain** used for this example.
![Alt text](/images/chain-of-trust.jpg "Chain of trust")
## Retrieve remote end-user certificate
The `s_client` option with OpenSSL is very helpful to retreive information from servers.
Use this command to initiate a connection on a TLS server.
```shell
echo "Q" | openssl s_client -connect www.example.com:443
```
>You can specify the TLS version, with `-tls1_1` , `-tls1_2`, `-tls1_3`, `-no_tls1_3` parameter.

Use this command to get the certificate from a remote host. The `-showcerts` flag will show the entire **certificate chain** in PEM format:
```shell
echo "Q" | openssl s_client -connect localhost:4443 -showcerts
```

Use this command to save the server certificate in a local PEM file `server.pem`.
```shell
echo "Q" | openssl s_client -connect localhost:443 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > server.pem
```
To save the entire **certificate chain**, use `-showcerts` parameter. The 1st certificate is the end-user (server), after the intermediate.s and the last one is the RootCA certificate.
```shell
echo "Q" | openssl s_client -connect localhost:443 -showcerts 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > server-chain.pem
```
## Verify the chain of trust
Use this command to building the chain of intermediate CA and RootCA certificates:
```shell
cat int-crt.pem ca-crt.pem > ca-chain.pem
```

Use this command to verify IntermediateCA via RootCA:
```shell
openssl verify -CAfile ca-crt.pem int-crt.pem
```

Use this command to verify the partial chain with server cert via IntermediateCA:
```shell
openssl verify -no-CAfile -no-CApath -partial_chain -trusted int-crt.pem server-crt.pem
```

Use this command to verify the server certificate via CA and SubCA Chain (same as below):
```shell
openssl verify -CAfile ca-crt.pem -untrusted int-crt.pem server-crt.pem
```

Use this command to verify the server certificate via CA and SubCA Chain (same as above):
```shell
openssl verify -show_chain -CAfile ca-chain.pem server-crt.pem
```
Output:
>```
>server-crt.pem: OK
>Chain:
>depth=0: C = CA, ST = QC, L = Montreal, O = Server, OU = IT, CN = Server.com (untrusted)
>depth=1: C = CA, ST = QC, L = Montreal, O = IntermediateCA, OU = IT, CN = SubRootCA.com
>depth=2: C = CA, ST = QC, L = Montreal, O = RootCA, OU = IT, CN = RootCA.com
>```
Use this command to verify the partial chain with Client cert via IntermediateCA
```shell
openssl verify -no-CAfile -no-CApath -partial_chain -trusted int-crt.pem client-crt.pem
```

Use this command to verify the client cert via IntermediateCA via RootCA
```shell
openssl verify -CAfile ca-crt.pem -untrusted int-crt.pem client-crt.pem
```

Use this command to verify the client via CA and SubCA Chain
```shell
openssl verify -CAfile ca-chain.pem client-crt.pem
```
## Verify the chain of trust manually
The best way to understand the signature verification process is to do it manually, aka the hard way 😀

### Extract the signature value from the certificate
I didn't find a cleaner way to get the signature from a certificate. I print the whole X.509 certificate and grab the last portion which is the signature.
```shell
openssl x509 -in server-crt.pem -text -noout -certopt ca_default \ 
-certopt no_validity -certopt no_serial -certopt no_subject \
-certopt no_extensions -certopt no_signame | grep -v 'Signature Algorithm' | \
sed 's/Signature Value//g' | tr -d '[:space:] [:punct:]' > signature.hex
```
The output is the signature, in hexadecimal, without any punctuation and line feeds. It's a plain text file.
```
68f449bf50 ... d3b561160a1d0b4a01a80ff79
```

### Extract the signature algorithm from the certificate
I don't use it for now but it will be usefull is future version of my script.
```shell
openssl x509 -in server-crt.pem -text -noout -certopt ca_default \
-certopt no_validity -certopt no_serial -certopt no_subject \
-certopt no_extensions -certopt no_signame | \
grep 'Signature Algorithm:' | sed 's/Signature Algorithm://g' | \
tr -d '[:space:]' > sig_algo.txt
```
The output should look like this:
>```
>sha256WithRSAEncryption
>```

### Convert the hexadecimal signature and dump it as a binary file
At this point the signature is in hexadecimal and encrypted with the private of the issuer. The following command creates a binary file with the encrypted certificate signature.
```shell
xxd -r -p signature.hex > sig-encrypted.bin
```

### Extract the public key from issuer certificate
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

### Decrypt the RSA signature from a binary encrypted signature
It takes the issuer public key to decrypt the signature from previous step. The output is a binary file with the decrypted certificate signature.
```shell
openssl pkeyutl -verifyrecover -pubin -inkey int-pubkey.pem -in sig-encrypted.bin -out sig-decrypted.bin
```
At this point we:
1. Downloaded the end-user certificate
2. Downloaded the issuer certificate
3. Extracted the issuer public key from its certificate
4. Decrypted the signature from the end-user certificate with the public key from the issuer

We have the decrypted signature of the end-user certificate. Lets see if this signature equals the one we calculate.

### Extract the body part of certificate without RSA signature part
This command extract the body part of the end-user certificate without the signatire. We will use the body part to calculate the signature and compare it to the decrypted one we calculated earlier. If they match then the issuer signed the end-user certificate.
```shell
openssl asn1parse -in server-crt.pem -noout -strparse 4 -out cert-body.bin
```
The output creates a bin file cert-body.bin of a certificate without signature.

### Calculate the hash of certificate body
```shell
openssl dgst -sha256 cert-body.bin -out sig_calculated.bin
```

### Lets compare the files
Lets compare the file `sig-decrypted.bin` and `sig_calculated.bin`. If they match, issuer signed the end-user certificate.
```shell
cmp -bl sig_calculated.bin sig-decrypted.bin
```

## Shell Script to automate the verification
I made a very simple script to automate the verification. It takes an end-user certificte, an issuer certificate and verify is the issuer really signed the certificate. You can find it [here](https://gist.github.com/ddella/bff877bc4929c5872bf06e9ddcf8ca4c). Remember this is for educational purposes **ONLY**.
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#Certificate-Chain-of-trust)  
[_< back to root_](../../../)
