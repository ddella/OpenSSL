# OpenSSL ECC Certificate Chain
This section will generate a full certificate chain using Elleptic Curve Cryptography.
1. RootCA certificate (self-signed)
2. Intermediate CA certificate
3. Server certificate  

One very important thing to remember is that **Extensions in certificate signing requests (CSR) are not transferred to certificates and vice versa**.
## ECC Root CA - Private/Public Key and certificate
Use this command to generate the private/public key of the RootCA.
```shell
openssl ecparam -name secp521r1 -genkey -out ca-key.pem
```
Use this command to generate a self-signed certificate for the RootCA. We don't generate a CSR (certificate signing request) for the RootCA since it's a self-signed certificate. The certificate will be valid for ~20 years (not couting leap years). You can customize it for your needs.
```shell
openssl req -new -sha256 -x509 -key ca-key.pem -days 7300 \
-subj "/C=CA/ST=QC/L=Montreal/O=RootCA/OU=IT/CN=RootCA.com" \
-addext "subjectAltName = DNS:localhost,DNS:*.localhost,DNS:RootCA.com,IP:127.0.0.1" \
-addext "basicConstraints = critical,CA:TRUE" \
-addext "keyUsage = critical, digitalSignature, cRLSign, keyCertSign" \
-addext "subjectKeyIdentifier = hash" \
-addext "authorityKeyIdentifier = keyid:always, issuer" \
-addext "authorityInfoAccess = caIssuers;URI:http://localhost:8000/Intermediate-CA.cer,OCSP;URI:http://localhost:8000/ocsp" \
-addext "crlDistributionPoints = URI:http://localhost:8000/crl/Root-CA.crl,URI:http://localhost:8080/crl/Intermediate-CA.crl" \
-out ca-crt.pem
```
## ECC Intermediate CA - Private/Public Key, CSR and certificate
Use this command to generate the private/public key of the intermediate CA.
```shell
openssl ecparam -name secp521r1 -genkey -out int-key.pem
```
Use this command to generate the CSR.
```shell
openssl req -new -sha256 -key int-key.pem \
-subj "/C=CA/ST=QC/L=Montreal/O=IntermediateCA/OU=IT/CN=SubRootCA.com" \
-addext "subjectAltName = DNS:localhost,DNS:*.localhost,DNS:SubRootCA.com,IP:127.0.0.1" \
-addext "basicConstraints = critical, CA:TRUE, pathlen:0" \
-addext "keyUsage = critical, digitalSignature, cRLSign, keyCertSign" \
-addext "subjectKeyIdentifier = hash" \
-addext "authorityInfoAccess = caIssuers;URI:http://localhost:8000/Intermediate-CA.cer,OCSP;URI:http://localhost:8000/ocsp" \
-addext "crlDistributionPoints = URI:http://localhost:8000/crl/Root-CA.crl,URI:http://localhost:8080/crl/Intermediate-CA.crl" \
-out int-csr.pem
```
Use this command to generate a certificate for the intermediate CA and have it signed by our RootCA. The certificate will be valid for ~10 years (not couting leap years).
```shell
openssl x509 -req -sha256 -days 3650 -in int-csr.pem -CA ca-crt.pem -CAkey ca-key.pem -CAcreateserial \
-extfile - <<<"subjectAltName = DNS:localhost,DNS:*.localhost,DNS:SubRootCA.com,IP:127.0.0.1
basicConstraints = critical, CA:TRUE, pathlen:0
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always, issuer
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
authorityInfoAccess = caIssuers;URI:http://localhost:8000/Intermediate-CA.cer,OCSP;URI:http://localhost:8000/ocsp
crlDistributionPoints = URI:http://localhost:8000/crl/Root-CA.crl,URI:http://localhost:8000/crl/Intermediate-CA.crl" \
-out int-crt.pem
```
## ECC Server CA - Private/Public Key, CSR and certificate
Use this command to generate the private/public key of the server certificate.
```shell
openssl ecparam -name prime256v1 -genkey -out server-key.pem
```
Use this command to generate the server CSR.
```shell
openssl req -new -sha256 -key server-key.pem -subj "/C=CA/ST=QC/L=Montreal/O=Server/OU=IT/CN=Server.com" \
-addext "subjectAltName = DNS:localhost,DNS:*.localhost,DNS:Server.com,IP:127.0.0.1" \
-addext "basicConstraints = CA:FALSE" \
-addext "extendedKeyUsage = serverAuth" \
-addext "subjectKeyIdentifier = hash" \
-addext "keyUsage = nonRepudiation, digitalSignature, keyEncipherment, keyAgreement, dataEncipherment" \
-addext "authorityInfoAccess = caIssuers;URI:http://localhost:8000/Intermediate-CA.cer,OCSP;URI:http://localhost:8000/ocsp" \
-addext "crlDistributionPoints = URI:http://localhost:8000/crl/Root-CA.crl,URI:http://localhost:8080/crl/Intermediate-CA.crl" \
-out server-csr.pem
```
Use this command to generate a certificate for the server and have it signed by our Intermediate CA.
```shell
openssl x509 -req -sha256 -days 365 -in server-csr.pem -CA int-crt.pem -CAkey int-key.pem -CAcreateserial \
-extfile - <<<"subjectAltName = DNS:localhost,DNS:*.localhost,DNS:Server.com,IP:127.0.0.1
basicConstraints = CA:FALSE
extendedKeyUsage = serverAuth
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid, issuer
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, keyAgreement, dataEncipherment
authorityInfoAccess = caIssuers;URI:http://localhost:8000/Intermediate-CA.cer,OCSP;URI:http://localhost:8000/ocsp
crlDistributionPoints = URI:http://localhost:8000/crl/Root-CA.crl,URI:http://localhost:8000/crl/Intermediate-CA.crl" \
-out server-crt.pem
```
## Making the chain of trust
The chain of trust, is a `PEM` file that includes all the Root/Intermediate certificates. It's usually not necessary to have **all** the certificates. You will almost never need the RootCA certificate as it's usually included in your trusted store with your OS or Firefox, as an example.  
In the case of OpenSSL, you need all certificates because it doesn't read any trust store by default.
```shell
cat int-crt.pem ca-crt.pem > ca-chain.pem
```
The file `ca-chain.pem` looks like:
```
-----BEGIN CERTIFICATE-----
MIIDSzCCAvGgAwIBAgIUNykNbc3v611Q/dQPubEmNxbRBzIwCgYIKoZIzj0EAwIw
...
usc6SGEGHL4uT0q1AS7zCHuBJFPj4g+z9WkYqLX/zQ==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIDOzCCAuCgAwIBAgIUFnTj4mss+lvg8dQ0jfVH5vUuIW8wCgYIKoZIzj0EAwIw
...
bXF+iDl8/RxBWFYS9DTE
-----END CERTIFICATE-----
```
## Verification
Verfying IntermediateCA via RootCA. Returns `int-crt.pem: OK`, if everything is fine.
```shell
openssl verify -CAfile ca-crt.pem int-crt.pem
```
Verfying Partial Chain with Server cert via IntermediateCA. Returns `server-crt.pem: OK`, if everything is fine.
```shell
openssl verify -no-CAfile -no-CApath -partial_chain -trusted int-crt.pem server-crt.pem
```
Verfying Server cert via IntermediateCA via RootCA. Returns `server-crt.pem: OK`, if everything is fine.
```shell
openssl verify -CAfile ca-crt.pem -untrusted int-crt.pem server-crt.pem
```
Verfying Server via CA and SubCA Chain. Returns `server-crt.pem: OK`, if everything is fine.
```shell
openssl verify -CAfile ca-chain.pem server-crt.pem
```
## Files created
If everything worked, you should have the following files in your local directory:
```
-rw-r--r--    2384 01 Jan 00:00 ca-chain.pem
-rw-r--r--@   1180 01 Jan 00:00 ca-crt.pem
-rw-------     302 01 Jan 00:00 ca-key.pem
-rw-r--r--@   1204 01 Jan 00:00 int-crt.pem
-rw-r--r--     976 01 Jan 00:00 int-csr.pem
-rw-------     302 01 Jan 00:00 int-key.pem
-rw-r--r--@   1212 01 Jan 00:00 server-crt.pem
-rw-r--r--     968 01 Jan 00:00 server-csr.pem
-rw-------     302 01 Jan 00:00 server-key.pem
```
***
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#OpenSSL-ECC-Certificate-Chain)  
[_< back to root_](../../../)
