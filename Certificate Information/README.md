# Extract information from a certificate
Commands to view the multiple fields in a TLS certificate.
## TLS certificate in PEM format
Use this command to view the contents of certificate `server-crt.pem`:
```shell
openssl x509 -text -noout -in server-crt.pem
```
![Alt text](/images/crt-pem.jpg "X.509 Certificate")
Use this command to display the certificate information in Abstract Syntax Notation One (ASN.1)
```shell
openssl asn1parse -in server-crt.pem
```

Use this command to view who issued certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -issuer
```
![Alt text](/images/crt-issuer.jpg "issuer")

Use this command to view the subject of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -subject
```
![Alt text](/images/crt-subject.jpg "subject")

Use this command to view the dates of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -dates
```
>use `-startdate` to print the **Not Before** field only  
>use `-enddate` to print the **Not After** field only  
![Alt text](/images/crt-dates.jpg "dates")

Use this command to see if the certificate `server-crt.pem` is a self-signed certificate. This will print a hash of the issuer and subject field. If both values are identical, then it's a self signed certificate.
```shell
openssl x509 -noout -in server-crt.pem -issuer_hash
openssl x509 -noout -in server-crt.pem -subject_hash
```

Use this command to see the purpose of certificate:
```shell
openssl x509 -noout -in server-crt.pem -purpose
```
Output is:
```
Certificate purposes:
SSL client : No
SSL client CA : No
SSL server : Yes
SSL server CA : No
Netscape SSL server : Yes
Netscape SSL server CA : No
S/MIME signing : No
S/MIME signing CA : No
S/MIME encryption : No
S/MIME encryption CA : No
CRL signing : No
CRL signing CA : No
Any Purpose : Yes
Any Purpose CA : Yes
OCSP helper : Yes
OCSP helper CA : No
Time Stamp signing : No
Time Stamp signing CA : No
```

Use this command to print the public key of certificate `server-crt.pem`, in PEM format:
```shell
openssl x509 -noout -in server-crt.pem -pubkey
```
Output is the equivalent of the public key `PEM` file:
```
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAECF1LmbobFvgyc3ZpE3pEbiUpOaKI
gO4zaQTR/4Z3OwdK8anx7CaXln4wTa5bo/IMVAhNrglqe2KuYNSqcdWKtw==
-----END PUBLIC KEY-----
```

Use this command to print the public key of certificate `server-crt.pem`, in HEX format:
```shell
openssl x509 -noout -in server-crt.pem -pubkey | openssl pkey -pubin -noout -text
```
![Alt text](/images/crt-pub.jpg "public key in hex")

The above all at once:
```shell
openssl x509 -noout -in server-crt.pem -issuer -subject -dates
```
```
issuer=C = CA, ST = QC, L = Montreal, O = IntermediateCA, OU = IT, CN = SubRootCA.com
subject=C = CA, ST = QC, L = Montreal, O = Server, OU = IT, CN = Server.com
notBefore=Nov 17 03:40:24 2022 GMT
notAfter=Nov 17 03:40:24 2023 GMT
```

Use this command to view the hash value of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -hash
```

Use this command to view the MD5 fingerprint of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -fingerprint
```

Use this command to view the modulus of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -modulus
```
>**Note**: Valid only for **RSA** key pair. If you try it on **ECC**, you'll get the following message:
>>Modulus=No modulus for this public key type
Use this command to view the SAN of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -ext subjectAltName
```
Use this command to view the basic constraints of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -ext basicConstraints
```
Use this command to view the authority infor access of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -ext authorityInfoAccess
```
Use this command to view the key usage of certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -ext keyUsage
```
***
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#Extract-information-from-a-certificate)  
[_< back to root_](../../../)
