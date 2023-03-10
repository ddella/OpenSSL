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
Output:
>```
>int-crt.pem: OK
>```

Use this command to verify the partial chain with server cert via IntermediateCA:
```shell
openssl verify -no-CAfile -no-CApath -partial_chain -trusted int-crt.pem server-crt.pem
```
Output:
>```
>server-crt.pem: OK
>```

Use this command to verify the server certificate via CA and SubCA Chain (same as below):
```shell
openssl verify -CAfile ca-crt.pem -untrusted int-crt.pem server-crt.pem
```
Output:
>```
>server-crt.pem: OK
>```

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
## Verify an RSA certificate signature by hand
[RSA Signature](RSA.md)
## Verify an ECDSA certificate signature by hand
[ECDSA Signature](ECDSA.md)
## Extract all certificates from chain
[Extract all certificates from chain](Extract-Cert.md)
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#Certificate-Chain-of-trust)  
[_< back to root_](../../../)
