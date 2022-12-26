# OpenSSL RSA Public Key Anatomy
**This applies to RSA keys only**. In this example I'm using a 512-bit public key. This is consider very insecure and should **never** be used in production.  
When we say a *512-bit public key*, it's the size of modulus, which is one component of the public key.  
The RSA Public Key is derived from the Private Key. We never generate a public key. We always generate a private key and that private key has the public key. They are both mathematically related.
## How big is a 512-bit key
Just to give you an idea of how large is a 512-bit number, it would look like:
1. ~154 decimal digits
2. 128 hexadeciaml digits

### How many decimal digits
If `n` is the number of digits, in base 10, you have to solve the equation 10<sup>n</sup> = 2<sup>512</sup>

Accoring to the **Laws of Exponents**
>log<sub>b</sub>(m<sup>r</sup>) = r ( log<sub>b</sub>m ) :: the log of `m` exponent `r` is `r` times the `log of m`  

10<sup>n</sup> = 2<sup>512</sup>  
n = log<sub>10(</sub>2<sup>512</sup>)  
n = 512 * log<sub>10</sub>2  
n ≈ 154  
### How many hexadecimal digits
If `n` is the number of digits in base 16, you have to solve the equation 16<sup>n</sup> = 2<sup>512</sup>

16<sup>n</sup> = 2<sup>512</sup>  
n = log<sub>16(</sub>2<sup>512</sup>)  
n = 512 * log<sub>16</sub>2  
n = 128  
>If `n` is the number of digits in base 16, just divide the number of bits by 4, since every hexadeciaml digit is exactly 4 bits.  
## Fields
This following information are always included in the public key file and in this order:
1. Modulus
2. Public Exponent

This applies to RSA public key only. It's based on a little bit of reverse engineering 😀
## RSA Public Key in PEM
The first thing to do is to convert the public key `PEM`file to haxadecimal. The `PEM` file is the base64 representation of the key. For this example, I generated a 512-bit RSA private key (you never generate a public key) to keep the numbers small but in reality this is insecure.
>RSA Public Key in Base64 PEM format
>```
>-----BEGIN PUBLIC KEY-----
>MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAMvjFzLpDIyNItZSl0Vb8WZxTbUkfijp
>YNw98KniEG0KIV4HHRa5lFDKA1T653xXInI8RbZQValpE24vMUdX/8kCAwEAAQ==
>-----END PUBLIC KEY-----
>```
## RSA Public Key in Hexadecimal
Convert the public key `PEM` file to hexadecimal.  
Check this script `pem2hex.sh` on my Gist [here](https://gist.github.com/ddella/d07d5b827f3638e727bbf3dc1210d4a2) to convert a `PEM` formatted file to hexadecimal.
```shell
./pem2hex.sh public-key.pem
```
```
30 5c 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 03 4b 00 30 48 02 41 00 cb e3 17 32 e9 
0c 8c 8d 22 d6 52 97 45 5b f1 66 71 4d b5 24 7e 28 e9 60 dc 3d f0 a9 e2 10 6d 0a 21 5e 07 
1d 16 b9 94 50 ca 03 54 fa e7 7c 57 22 72 3c 45 b6 50 55 a9 69 13 6e 2f 31 47 57 ff c9 02 
03 01 00 01
```
## RSA Public Key in Hexadecimal
Use this command to get the public key detail:
```shell
openssl pkey -text -noout -in public-key.pem
```
The top left side of the table is the output of the preceding command. The top righ side of the table is the hexadecimal representation of the base64 PEM file.  
The bottom portion of the table represents the decoded values of every fields in an RSA public key.  
Representation of an RSA 512-bit public key in hexadecimal.

![Alt text](/images/rsa-pub-key-hex.jpg "RSA Public key in hex format")  
To get the OID value from hexadecimal, I used the simple script made by Matthias Gaertner found [here](https://www.rtner.de/software/oid.html)  
To compile, just use GCC/Apple clang:
```shell
gcc -Wall oid.c -o oid
```
To get the OID value, just type:
```shell
./oid -x 06092a864886f70d010101
```
The ouput should be:
```
UNIVERSAL OID.1.2.840.113549.1.1.1
```
## OpenSSL ASN.1 Parser
OpenSSL includes an ASN.1 parser. The numbers is the first column are in hexadecimal. They represent the byte offset of the binary public key file.
```shell
openssl asn1parse -inform pem -in public-key.pem -strparse 20
```
```
 0:d=0  hl=2 l=  72 cons: SEQUENCE
 2:d=1  hl=2 l=  65 prim: INTEGER       :CBE31732E90C8C8D22D65297455BF166714DB5247E28E960DC3DF0A9E2106D0A215E071D16B99450CA0354FAE77C5722723C45B65055A969136E2F314757FFC9
69:d=1  hl=2 l=   3 prim: INTEGER       :010001
```
![Alt text](/images/rsa-pub-key-asn.jpg "RSA Public key in ASN.1")
## RSA Public Key with a bit of math
Representation of an RSA 512-bit public key with a bit of math. I wanted to keep this as simple as possible. It gives an idea of how those numbers are calculated. In reality, there's way more than what you see here.  
## OID values
The representation of the OID was taken from Microsoft [here](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gpnap/ff1a8675-0008-408c-ba5f-686a10389adc)
![Alt text](/images/key-oid.jpg "Key pair OID")
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#OpenSSL-RSA-Public-Key-Anatomy)  
[_< back to root_](../../../)
