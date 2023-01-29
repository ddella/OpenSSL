<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

# RSA Private and Public Key Anatomy
**This applies to RSA keys only**. In this example I'm using a 512-bit private key. This is consider very insecure and should **never** be used in production.  
For RSA, when we say a 512-bit key, it's the size of the modulus, which is one component of the public and private key.
The private key is a key pair of the private exponent (**d**) and the modulus (**n**). It is presented as follow: (**d,n**)

1. The private exponent **d**
2. The modulus **n** is the product of two large prime numbers
>**Note**: The modulus (**n**) is the same number for the private and public key  

The RSA Public Key is derived from the Private Key. We never generate a public key. We always generate a private key and that private key has the public key. They are both mathematically related.

## How big is a 512-bit key
Just to give you an idea of how large is a 512-bit number, it would look like:
1. ~154 decimal digits
2. 128 hexadecimal digits

### How many decimal digits
If `n` is the number of digits in base 10, you have to solve the equation 10<sup>n</sup> = 2<sup>512</sup>

Accoring to the **Laws of Exponents**
>log<sub>b</sub>(m<sup>r</sup>) = r ( log<sub>b</sub>m ) :: the log of `m` exponent `r` is `r` times the `log of m`  

10<sup>n</sup> = 2<sup>512</sup>  
n = log<sub>10(</sub>2<sup>512</sup>)  
n = 512 * log<sub>10</sub>2  
n ≈ 154  
### How many hexadecimal digits
If `n` is the number of digits, in base 16, just divide the number of bits by 4, since every hexadecimal digit is exactly 4 bits or do the same math as for decimal execpt that the base is 16 instead of 10.    
If `n` is the number of digits in base 16, you have to solve the equation 16<sup>n</sup> = 2<sup>512</sup>

16<sup>n</sup> = 2<sup>512</sup>  
n = log<sub>16(</sub>2<sup>512</sup>)  
n = 512 * log<sub>16</sub>2  
n = 128  
<p align="right">(<a href="#readme-top">back to top</a>)</p>
  
## Fields
This following information are always included in the private key and in this order:
1. Modulus
2. Public Exponent
3. Private Exponent
4. Prime number 1
5. Prime number 2
6. Exponent 1
7. Exponent 2
8. Coefficient

This applies to RSA private key only. It's based on [RSA Private Key Breakdown](http://etherhack.co.uk/asymmetric/docs/rsa_key_breakdown.html) and a little bit of reverse engineering 😀
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## RSA Private Key in PEM
The first thing to do is to convert the private key `PEM` file to hexadecimal. The `PEM` file is a base64 representation of the key. For this example, I generated a 512-bit RSA private key to keep the numbers small but in reality this is insecure.
Use this command to generate an RSA 512-bit private key:
```shell
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:512 -out RSA-private-key.pem
```
To view the RSA Private Key in PEM (base64) format, just type:
```shell
cat RSA-private-key.pem
```
>RSA Private Key in Base64 PEM format
>```
>-----BEGIN PRIVATE KEY-----
>MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAy+MXMukMjI0i1lKX
>RVvxZnFNtSR+KOlg3D3wqeIQbQohXgcdFrmUUMoDVPrnfFcicjxFtlBVqWkTbi8x
>R1f/yQIDAQABAkB8pjqxql88srDAvT+0bNC6I70xaL0kwAGyxL+U7RvDvR1H5uMc
>nYI492dJjtite8zM7GehvrKaIUQlE/T6Wa9xAiEA6/T0/qTKXkw4pDF8I88v7qM9
>H0hSyUAfL2EOFcVDUIUCIQDdNMEOzQQrP7QE6MOOce18bLpcAMHC+HlAwFx7m4tX
>dQIgTv7aiuo2yi0whV//1KlHvdgu3WtENBZgmmce5RD+wVUCIEgPGFje9l20WctD
>m/i6KjffH3I7GOOPl8g9IaNujxzFAiEA3RnIYC6a3FvPz82hXZ8YQgmuzANzGxB5
>u8QvL7v2p4g=
>-----END PRIVATE KEY-----
>```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## RSA Private Key in Hexadecimal
Convert the private key `PEM` file to hexadecimal.  
Check this script `pem2hex.sh` on my Gist [here](https://gist.github.com/ddella/d07d5b827f3638e727bbf3dc1210d4a2) to convert a `PEM` formatted file to hexadecimal.
```shell
./pem2hex.sh RSA-private-key.pem
```
The hexadecimal representation of the `PEM` file:
>```
>30 82 01 54 02 01 00 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 04 82 01 
>3e 30 82 01 3a 02 01 00 02 41 00 cb e3 17 32 e9 0c 8c 8d 22 d6 52 97 45 5b 
>f1 66 71 4d b5 24 7e 28 e9 60 dc 3d f0 a9 e2 10 6d 0a 21 5e 07 1d 16 b9 94 
>50 ca 03 54 fa e7 7c 57 22 72 3c 45 b6 50 55 a9 69 13 6e 2f 31 47 57 ff c9 
>02 03 01 00 01 02 40 7c a6 3a b1 aa 5f 3c b2 b0 c0 bd 3f b4 6c d0 ba 23 bd 
>31 68 bd 24 c0 01 b2 c4 bf 94 ed 1b c3 bd 1d 47 e6 e3 1c 9d 82 38 f7 67 49 
>8e d8 ad 7b cc cc ec 67 a1 be b2 9a 21 44 25 13 f4 fa 59 af 71 02 21 00 eb 
>f4 f4 fe a4 ca 5e 4c 38 a4 31 7c 23 cf 2f ee a3 3d 1f 48 52 c9 40 1f 2f 61 
>0e 15 c5 43 50 85 02 21 00 dd 34 c1 0e cd 04 2b 3f b4 04 e8 c3 8e 71 ed 7c 
>6c ba 5c 00 c1 c2 f8 79 40 c0 5c 7b 9b 8b 57 75 02 20 4e fe da 8a ea 36 ca 
>2d 30 85 5f ff d4 a9 47 bd d8 2e dd 6b 44 34 16 60 9a 67 1e e5 10 fe c1 55 
>02 20 48 0f 18 58 de f6 5d b4 59 cb 43 9b f8 ba 2a 37 df 1f 72 3b 18 e3 8f 
>97 c8 3d 21 a3 6e 8f 1c c5 02 21 00 dd 19 c8 60 2e 9a dc 5b cf cf cd a1 5d 
>9f 18 42 09 ae cc 03 73 1b 10 79 bb c4 2f 2f bb f6 a7 88
>```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## RSA Private Key in detail
Use this command to get the RSA private key detail:
```shell
openssl pkey -text -noout -in RSA-private-key.pem
```
The left side of the table is the output of the preceding command. The righ side of the table is the hexadecimal representation of the base64 PEM file.  

Representation of an RSA 512-bit private key in hexadecimal.  
![Alt text](/images/rsa-priv-key-hex.jpg "RSA Private key in hex format")
Each field of the private key.  
![Alt text](/images/rsa-priv-key-tags.jpg "RSA Private key tags")
ASN.1 format. I used the value `0x3082` as an example.  
![Alt text](/images/asn-1-tag.jpg "X.690 ASN.1 tags")
>For more information on the X.690 specification, take a look on [Wikipedia](https://en.wikipedia.org/wiki/X.690)
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## OID value representation
To get the OID value from hexadecimal, I used a simple script by Matthias Gaertner found [here](https://www.rtner.de/software/oid.html) or on my Gist [here](https://gist.github.com/ddella/2c716646125912a6ef8bed6273f647f2)  
To compile, just use GCC/Apple clang:
```shell
gcc -Wall oid.c -o oid
```
To get the OID value, just type:
```shell
./oid -x 06092a864886f70d010101
```
The ouput should be:
>```
>UNIVERSAL OID.1.2.840.113549.1.1.1
>```
The representation of the OID was taken from Microsoft [here](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gpnap/ff1a8675-0008-408c-ba5f-686a10389adc)
![Alt text](/images/key-oid-rsa.jpg "Key pair OID")
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## OpenSSL ASN.1 Parser
OpenSSL includes an ASN.1 parser. The numbers is the first column are in hexadecimal. They represent the byte offset of the binary private key file.
```shell
openssl asn1parse -inform pem -in RSA-private-key.pem -strparse 22
```
```
  0:d=0  hl=4 l= 314 cons: SEQUENCE          
  4:d=1  hl=2 l=   1 prim: INTEGER    :00
  7:d=1  hl=2 l=  65 prim: INTEGER    :CBE31732E90C8C8D22D65297455BF166714DB5247E28E960DC3DF0A9E2106D0A215E071D16B99450CA0354FAE77C5722723C45B65055A969136E2F314757FFC9
 74:d=1  hl=2 l=   3 prim: INTEGER    :010001
 79:d=1  hl=2 l=  64 prim: INTEGER    :7CA63AB1AA5F3CB2B0C0BD3FB46CD0BA23BD3168BD24C001B2C4BF94ED1BC3BD1D47E6E31C9D8238F767498ED8AD7BCCCCEC67A1BEB29A21442513F4FA59AF71
145:d=1  hl=2 l=  33 prim: INTEGER    :EBF4F4FEA4CA5E4C38A4317C23CF2FEEA33D1F4852C9401F2F610E15C5435085
180:d=1  hl=2 l=  33 prim: INTEGER    :DD34C10ECD042B3FB404E8C38E71ED7C6CBA5C00C1C2F87940C05C7B9B8B5775
215:d=1  hl=2 l=  32 prim: INTEGER    :4EFEDA8AEA36CA2D30855FFFD4A947BDD82EDD6B443416609A671EE510FEC155
249:d=1  hl=2 l=  32 prim: INTEGER    :480F1858DEF65DB459CB439BF8BA2A37DF1F723B18E38F97C83D21A36E8F1CC5
283:d=1  hl=2 l=  33 prim: INTEGER    :DD19C8602E9ADC5BCFCFCDA15D9F184209AECC03731B1079BBC42F2FBBF6A788
```
The next graphic is the same output as the above but with each components colored.  
![Alt text](/images/rsa-priv-key-asn.jpg "RSA Private key in ASN.1")
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## RSA Private Key with a bit of math
Representation of an RSA 512-bit private key with a bit of math. I wanted to keep this as simple as possible. It gives an idea of how those numbers are calculated. In reality, it's way more complicated than what you see here.  

![Alt text](/images/rsa-priv-key.jpg "RSA Private key")
***
## Files
The file `RSA-private-key.pem` is the RSA private key.  
```shell
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:512 -out RSA-private-key.pem
```
The file `RSA-private-key.bin` is the binary representation of the RSA private key `PEM` file.  
```shell
openssl enc -d -base64 -in RSA-private-key.pem -out RSA-private-key.bin
```
The file `RSA-public-key.pem` is the RSA public key extracted from the private key `PEM` file.  
```shell
openssl pkey -in RSA-private-key.pem -pubout -out RSA-public-key.pem
```
The binary file is 344 octets. According to the header in the hexadecimal dump of the private key, the size is 0x0154 (340) octets plus the 4 octets for the header. That equals to 344 octets of the binary file.  
```
-rw-r--r--   1 username  staff   344 01 Jan 00:00 RSA-private-key.bin
-rw-------   1 username  staff   522 01 Jan 00:00 RSA-private-key.pem
-rw-r--r--   1 username  staff   182 01 Jan 00:00 RSA-public-key.pem
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
# License
Distributed under the MIT License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
# Contact
Daniel Della-Noce - [Linkedin](https://www.linkedin.com/in/daniel-della-noce-2176b622/) - daniel@isociel.com

Project Link: [https://github.com/ddella/OpenSSL](https://github.com/ddella/OpenSSL)
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
# Acknowledgments
* [OpenSSL](https://www.openssl.org/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
<p align="right">(<a href="../">back to root</a>)</p>
