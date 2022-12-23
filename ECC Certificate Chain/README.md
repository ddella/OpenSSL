# OpenSSL ECC Certificate Chain
This section will generate a full certificate chain using Elleptic Curve Cryptography.
1. RootCA certificate (self-signed)
2. Intermediate CA certificate
3. Server certificate
## ECC Root CA - Private/Public Key and certificate
Use this command to generate the private/public key of the RootCA.
```shell
openssl ecparam -name secp521r1 -genkey -out ca-key.pem
```
Use this command to generate a self-signed certificate for the RootCA. We don't generate a CSR (certificate signing request) for the RootCA since it's a self-signed certificate.
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
Use this command to generate a certificate for the intermediate CA and have it signed by our RootCA.
```shell
openssl x509 -req -sha256 -days 365 -in int-csr.pem -CA ca-crt.pem -CAkey ca-key.pem -CAcreateserial \
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
## Files created
If everything worked, you should have the follwoing files in your directory:
```
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
