# Extract all certificates from chain
This example shows wow to extract all the certificates from a PEM file containing the full certificate chain, including the server certificate. The PEM file `certificate-chain.pem` contains the server certificate, the intermediate certificate and the root certificate.

This is a two (2) step process:
1. Dump all the certificates in separate files, from `certificate-chain.pem`. This will create multiple `cert?.pem` files
2. Rename the files `cert?.pem` with their corresponding common name (CN)

## 1. Dump all the certificates in separate files
Run the following command to dump all the certificates in the chain as `cert${chain_number}.pem`:
```shell
openssl storeutl -certs certificate-chain.pem < /dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ if(/BEGIN CERTIFICATE/){id++}; out="cert"id".pem"; print >out}'
```

Files:
```
-rw-r--r--  1 username  staff  1212  1 Jan 00:00 cert1.pem
-rw-r--r--  1 username  staff  1204  1 Jan 00:00 cert2.pem
-rw-r--r--  1 username  staff  1180  1 Jan 00:00 cert3.pem
-rw-r--r--  1 username  staff  3597  1 Jan 00:00 certificate-chain.pem
```

## 2. Rename the files
Run the following command to rename the files with their corresponding common name (CN):
```shell
for cert in cert?.pem; do 
   newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem
   mv $cert $newname
done
```

Files:
```
-rw-r--r--  1 username  staff  1180  1 Jan 00:00 rootca_com.pem
-rw-r--r--  1 username  staff  1212  1 Jan 00:00 server_com.pem
-rw-r--r--  1 username  staff  1204  1 Jan 00:00 subrootca_com.pem
```
## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Extract-all-certificates-from-chain)  
[_< back to Certificate Chain of trust page_](README.md)  
[_<< back to root_](../../../)
