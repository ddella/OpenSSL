# Digital Signature
A digital signature is an electronic signature. It provides an encrypted stamp of authentication and digital ID to confirm information originated from them. A signer's digital certificate is used to create the signature and then attach it to the signed document.

Digital signature provides:
1. **Authentication**: Digital signatures can be used to authenticate the identity of the source messages. A valid signature shows that the message was sent by a specific user.
2. **Integrity**: Assure that the message has not been altered during transmission. If a message is digitally signed, any change in the message after signature invalidates the signature.
3. **Non-repudiation**: An entity that has signed a message cannot at a later time deny having signed it.
## RSA signature with OpenSSL
[RSA Signature](RSA-Sig.md)
## ECDSA signature with OpenSSL
In this section I'll walk through the process to perform ECDSA signature on a a bogus binary file. That will work on any type of data.  
1. Generate a private key, this will also generate the corresponding public key
2. Extract the public key, from the private key
3. Convert the ECC public key in DER and PEM format
4. View the public key content
5. Generate a hash
6. Create a signature using the private key and the hash
7. View the content of the signature
8. Verify the signature  

[ECDSA Signature](ECDSA-Sig.md)
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#Digital-Signature)  
[_< back to root_](../../../)
