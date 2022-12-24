# Extract information from a certificate
Commands to view the multiple fields in a TLS certificate.
## TLS certificate in PEM format
Use this command to view the contents of a certificate `server-crt.pem`:
```shell
openssl x509 -text -noout -in server-crt.pem
```

Use this command to display the certificate information in Abstract Syntax Notation One (ASN.1)
```shell
openssl asn1parse -in server-crt.pem
```

Use this command to view who issued the certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -issuer
```
![Alt text](/images/crt-issuer.jpg "issuer")

Use this command to view the subject of the certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -subject
```

Use this command to view the dates of the certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -dates
```

Use this command to see if the certificate `server-crt.pem` is a self-signed certificate:
```shell
openssl x509 -noout -in server-crt.pem -issuer_hash
openssl x509 -noout -in server-crt.pem -subject_hash
```
>If both output are identical, it's a self signed certificate.

Use this command to see the purpose of the certificate:
```shell
openssl x509 -noout -in server-crt.pem -purpose
```

Use this command to print the public key of the certificate `server-crt.pem`, in PEM format:
```shell
openssl x509 -noout -in server-crt.pem -pubkey
```

Use this command to print the public key of the certificate `server-crt.pem`, in HEX format:
```shell
openssl x509 -noout -in server-crt.pem -pubkey | openssl pkey -pubin -noout -text
```

The above all at once:
```shell
openssl x509 -noout -in server-crt.pem -issuer -subject -dates
```

Use this command to view the hash value of the certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -hash
```

Use this command to view the MD5 fingerprint of the certificate `server-crt.pem`:
```shell
openssl x509 -noout -in server-crt.pem -fingerprint
```

Use this command to view the SAN of the certificate `server-crt.pem`:
```shell
echo|openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -text | grep "Subject Alternative Name" -A2 | grep -Eo "DNS:[a-zA-Z 0-9.*-]*" | sed "s/DNS://g"
```
***
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#Extract-information-from-a-certificate)  
[_< back to root_](../../../)
