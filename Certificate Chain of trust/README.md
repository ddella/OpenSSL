# Certificate Chain of trust
**Certificate Chain** or **Chain of Trust** is made up of a list of certificates that start from the end-user certificate and terminate with the root certificate. The **chain of trust** is an ordered list of certificates, containing an end-user (server) certificate, one or more intermediate certificate.s and a RootCA.

If your end-user certificate is to be trusted, its signature has to be traceable back to its root CA. In the certificate chain, every certificate is signed by the entity that is identified by the next certified along the chain, except the RootCA which is a self-signed certificate.


The `s_client` option with OpenSSL is very helpful to retreive information from servers.
1. Troubleshooting remote TLS connections
2. Retreive information like servers certificate chain
3. Details about the TLS handshake, its verification, and the TLS version and cipher will be returned

## Retreive remote server certificate
Use this command to display diagnostic information about the TLS connection to the server.
```shell
echo "Q" | openssl s_client -connect www.example.com:443
```
>You can specify the TLS version, with `-tls1_1` , `-tls1_2`, `-tls1_3`, `-no_tls1_3` parameter.

Use this command to get the certificate from a remote host. The `-showcerts` flag will show the entire certificate chain in PEM format:
```shell
echo "Q" | openssl s_client -connect localhost:4443 -showcerts
```

This commands save the server certificate in a local PEM file server.pem.
```shell
echo "Q" | openssl s_client -connect localhost:443 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > server.pem
```
>**Note**: To save the entire certificate chain, use `-showcerts` parameter. The 1st certificate is the server, after the intermediate(s) and the last one is the RootCA.

```shell
echo "Q" | openssl s_client -connect localhost:443 -showcerts 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > qc-chain.pem
```

SNI is a TLS extension that supports one host or IP address to serve multiple hostnames so that host and IP no longer have to be one to one.
Use this command to specify the server name:
```shell
openssl s_client -connect example.com:443 -servername www.example.com
```

You can pass a cipher to the openssl `s_client` command with the `-ciphersuites` flag.
```shell
echo "Q" | openssl s_client -connect www.example.com:443 -tls1_3 -ciphersuites TLS_AES_128_GCM_SHA256 2>/dev/null | grep New
```
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#Certificate-Chain-of-trust)  
[_< back to root_](../../../)
