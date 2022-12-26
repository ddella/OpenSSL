# ECC Private Public Key Anatomy
**This applies to ECC key only**. In this example I'm using a 256-bit ECC key.  
The public key in ECC are EC points - pairs of integer coordinates {x, y}, laying on a curve.  
1.	Starting point on a curve
2.	Ending point on a curve  

The private key represents the number of hops on a curve to go from start to end.  
The ECC Public Key is derived from the Private Key. We never generate a public key. We always generate a private key and that private key has the public key. They are both mathematically related.  
## How big is a 256-bit key
Just to give you an idea of how large is a 256-bit number, it would look like:
1. ~77 decimal digits
2. 64 hexadeciaml digits

### How many decimal digits
If `n` is the number of digits, in base 10, you have to solve the equation 10<sup>n</sup> = 2<sup>256</sup>

10<sup>n</sup> = 2<sup>256</sup>  
n = log<sub>10(</sub>2<sup>256</sup>)  
n = 256 * log<sub>10</sub>2  
n ≈ 77  
>Accoring to the **Laws of Exponents**:  
>log<sub>b</sub>(m<sup>r</sup>) = r ( log<sub>b</sub>m ) :: the log of `m` exponent `r` is `r` times the `log of m`  

### How many hexadecimal digits
If `n` is the number of digits in base 16, you have to solve the equation 16<sup>n</sup> = 2<sup>512</sup>

16<sup>n</sup> = 2<sup>256</sup>  
n = log<sub>16(</sub>2<sup>256</sup>)  
n = 256 * log<sub>16</sub>2  
n = 64  
>If `n` is the number of digits in base 16, just divide the number of bits by 4, since every hexadeciaml digit is exactly 4 bits.  
## Fields
There's way less information in an ECC key-pair than with RSA. The only information included are the Private, Public Keys and the OID to identify the type of keys.  
>This might not be accurate. Everything is based on a lots of reading and a bit of reverse engineering 😀  
## ECC Key-Pair in PEM
The first thing to do is to convert the private key `PEM`file to haxadecimal. The `PEM` file is the base64 representation of the keys. For this example, I generated a 256-bit ECC private key, you never generate a public key.
>ECC Key-pair in PEM format
```shell
cat ecc-private-key.pem
```
>```
>-----BEGIN EC PRIVATE KEY-----
>MHcCAQEEIKioNIShCCQg9DHzRfhfg/YpdklefcfMYguTy6Rb/sbooAoGCCqGSM49
>AwEHoUQDQgAEXhrbk2EX8sKScXgNTaiWpfrBA9xo1SgWwu7dxDkKVRtFe76Twv+4
>sSqzV4nUf7o+JJq6FNyufos7GlY2zjYcUQ==
>-----END EC PRIVATE KEY-----
>```
## ECC Private Key in Hexadecimal
Convert the private key `PEM` file to hexadecimal.  
Check this script `pem2hex.sh` on my Gist [here](https://gist.github.com/ddella/d07d5b827f3638e727bbf3dc1210d4a2) to convert a `PEM` formatted file to hexadecimal.
```shell
./pem2hex.sh ecc-private-key.pem
```
```
30 77 02 01 01 04 20 a8 a8 34 84 a1 08 24 20 f4 31 f3 45 f8 5f 83 f6 29 76 49 5e 7d c7 cc 
62 0b 93 cb a4 5b fe c6 e8 a0 0a 06 08 2a 86 48 ce 3d 03 01 07 a1 44 03 42 00 04 5e 1a db 
93 61 17 f2 c2 92 71 78 0d 4d a8 96 a5 fa c1 03 dc 68 d5 28 16 c2 ee dd c4 39 0a 55 1b 45 
7b be 93 c2 ff b8 b1 2a b3 57 89 d4 7f ba 3e 24 9a ba 14 dc ae 7e 8b 3b 1a 56 36 ce 36 1c 
51
```
![Alt text](/images/ecc-key-pair-hex.jpg "ECC key pair in hex format")  
## ECC Key-Pair detail
Use this command to get the ECC private key details:
```shell
openssl ec -in ecc-private-key.pem -noout -text
```
The top left side of the table is the output of the preceding command. The top righ side of the table is the hexadecimal representation of the base64 PEM file.  
The bottom portion of the table represents the decoded values of every fields in an ECC private key.  
![Alt text](/images/ecc-key-pair-detail.jpg "ECC key-pair detail")  
To get the OID value from hexadecimal, I used a simple script made by Matthias Gaertner found [here](https://www.rtner.de/software/oid.html)  
To compile, just use GCC/Apple clang:
```shell
gcc -Wall oid.c -o oid
```
To get the OID value, just type:
```shell
./oid -x 06082a8648ce3d030107 
```
>This is what I meant when I said *a bit of reverse engineering*. I was left with some fields and I tried the get the OID value and found a match 😀
The ouput should be:
```
UNIVERSAL OID.1.2.840.10045.3.1.7
```
## OID value representation
The representation of the OID was taken from Microsoft [here](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gpnap/ff1a8675-0008-408c-ba5f-686a10389adc)
![Alt text](/images/key-oid-ecc.jpg "Key pair OID")
## OpenSSL ASN.1 Parser
OpenSSL includes an ASN.1 parser. The numbers is the first column are in hexadecimal. They represent the byte offset of the binary private key file.
```shell
openssl asn1parse -inform pem -in ecc-private-key.pem
```
```
 0:d=0  hl=2 l= 119 cons: SEQUENCE
 2:d=1  hl=2 l=   1 prim: INTEGER           :01
 5:d=1  hl=2 l=  32 prim: OCTET STRING      [HEX DUMP]:A8A83484A1082420F431F345F85F83F62976495E7DC7CC620B93CBA45BFEC6E8
39:d=1  hl=2 l=  10 cons: cont [ 0 ]
41:d=2  hl=2 l=   8 prim: OBJECT            :prime256v1
51:d=1  hl=2 l=  68 cons: cont [ 1 ]
53:d=2  hl=2 l=  66 prim: BIT STRING
```
## Files
The file `ecc-private-key.pem` is the ECC private key that I generated.  
The file `ecc-private-key.bin` is the binary representation of the ECC private key `PEM` file.  
The file `ecc-public-key.pem` is the ECC public key extracted from the private key `PEM` file.  
The binary file is 121 bytes. According to the header in the hexadecimal dump of the private key `PEM` file the size if 0x77 bytes plus the 2 bytes of the header which equals to 121 bytes.  
```
-rw-r--r--  1 username  staff  121 01 Jan 00:00 ecc-private-key.bin  
-rw-------@ 1 username  staff  227 01 Jan 00:00 ecc-private-key.pem  
-rw-r--r--  1 username  staff  178 01 Jan 00:00 ecc-public-key.pem  
```
## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#ECC-Private-Public-Key-Anatomy)  
[_< back to root_](../../../)
