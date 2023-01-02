# Digital Signature
A digital signature of a message is a fingerprint (hash) dependent on some secret (private key) known only to the signer. Signatures must be verifiable without requiring access to the signer’s secret information (private key). One of the significant applications of digital signatures is the certification of PKI certificate.

The verification process of a digital signature consists of
1. a verification algorithm
    * RSA signature
    * ECDSA signature
2. a method for recovering data without the signature

The digital signatures viewed here are applied to messages of fixed length called *hash value*. A hash of the message is calculated. This hash is signed with the private key of the sender of the data.  The receiver use the public key to get the hash and calculate is own hash against the received data. If both hash match, then the data has not been modified in transit.  

Digital signature provides:
1. **Authentication**: Digital signatures can be used to authenticate the identity of the source messages. A valid signature shows that the message was sent by a specific user.
2. **Integrity**: Assure that the message has not been altered during transmission. If a message is digitally signed, any change in the message after signature invalidates the signature.
3. **Non-repudiation**: An entity that has signed a message cannot at a later time deny having signed it.

A **hash** functions transform *variable* length data to a *fixed-length* value and is known to be collision-resistant and irreversible (a one-way function). Two random inputs would yield the same hash with probability 2<sup>−n</sup>. The basic idea of hash functions is that a hash-value serves as a compact representation of the input data. It sometimes called a digital fingerprint or message digest.

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
