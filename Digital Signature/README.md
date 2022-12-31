# Digital Signature
A digital signature is an electronic signature. It provides an encrypted stamp of authentication and digital ID to confirm information originated from them. A signer's digital certificate is used to create the signature and then attach it to the signed document.

Digital signature provides:
1. **Authentication**: Digital signatures can be used to authenticate the identity of the source messages. A valid signature shows that the message was sent by a specific user.
2. **Integrity**: Assure that the message has not been altered during transmission. If a message is digitally signed, any change in the message after signature invalidates the signature.
3. **Non-repudiation**: An entity that has signed a message cannot at a later time deny having signed it.
## RSA signature with OpenSSL
This article shows a practical example of how to generate and verify an RSA signature using OpenSSL.  
[RSA Signature](RSA-Sig.md)
## ECDSA signature with OpenSSL
This article shows a practical example of how to generate and verify an Elliptic Curve Digital Signature Algorithm (ECDSA) using OpenSSL. 
[ECDSA Signature](ECDSA-Sig.md)
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#Digital-Signature)  
[_< back to root_](../../../)
