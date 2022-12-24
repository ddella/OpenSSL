# OpenSSL RSA Certificate Chain (INCOMPLETE)
This section will generate a full certificate chain using RSA Cryptography. If you prefer using ECC, check my other repository [here](https://github.com/ddella/OpenSSL/tree/main/ECC%20Certificate%20Chain)
1. RootCA certificate (self-signed)
2. Intermediate CA certificate
3. Server certificate  

All the scripts in this tutorial have been tested on macOS with `zsh`. They should work on any version of Linux with `bash`.  
One very important thing to remember is that **extensions in certificate signing requests (CSR) are not transferred to certificates**.  
The full script to generate this certificate chain is on my Gist [here](https://gist.github.com/ddella/xxxx).

## Generate certificates
I made a small `quick and dirty` script to generate certificates for testing purposes only. This script assume to many things starting by the file naming convention. It assumes you followed this procedure to create your certificate chain.   
The script to generate standard TLS server certificates is on my Gist [here](https://gist.github.com/ddella/xxxx).
***
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#OpenSSL-RSA-Certificate-Chain)  
[_< back to root_](../../../)
