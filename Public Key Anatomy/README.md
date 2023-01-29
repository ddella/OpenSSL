# OpenSSL RSA Public Key Anatomy
**This applies to RSA key only**. In this example I'm using a 512-bit public key. This is consider very insecure and should **never** be used in production.  
For RSA, when we say a *512-bit key*, it's the size of the modulus, which is one component of the public and private key.  
The public key is a key pair of the public exponent (**e**) and the modulus (**n**). It is presented as follow: (**e,n**)

1.	The public exponent **e** (almost always 65537)
2.	The modulus **n** is the product of two large prime numbers  
>**Note**: The modulus (**n**) is the same number for the private and public key  

The RSA Public Key is derived from the Private Key. We never generate a public key. We always generate a private key and that private key has the public key. They are both mathematically related.
## How big is a 512-bit key
Just to give you an idea of how large is a 512-bit number, it would look like:
1. ~154 decimal digits
2. 128 hexadecimal digits

### How many decimal digits
If `n` is the number of digits in base 10, you have to solve the equation 10<sup>n</sup> = 2<sup>512</sup>

10<sup>n</sup> = 2<sup>512</sup>  
n = log<sub>10(</sub>2<sup>512</sup>)  
n = 512 * log<sub>10</sub>2  
n ≈ 154  
>Accoring to the **Laws of Exponents**:  
>log<sub>b</sub>(m<sup>r</sup>) = r ( log<sub>b</sub>m ) => log of `m` exponent `r` is `r` times `log of m`   

### How many hexadecimal digits
If `n` is the number of digits in base 16, you have to solve the equation 16<sup>n</sup> = 2<sup>512</sup>

16<sup>n</sup> = 2<sup>512</sup>  
n = log<sub>16(</sub>2<sup>512</sup>)  
n = 512 * log<sub>16</sub>2  
n = 128  
>If `n` is the number of digits in base 16, just divide the number of bits by 4, since every hexadecimal digit is exactly 4 bits.  
## Fields
This following information are always included in the RSA public key file and in this order:
1. Modulus
2. Public Exponent

This applies to RSA public key only. It's based on a lot of readings, especially this [site](https://www.cem.me/20141221-cert-binaries.html) and a little bit of reverse engineering 😀  

## License
This project is licensed under the [MIT license](/LICENSE).

[_^ back to top_](#OpenSSL-RSA-Public-Key-Anatomy)  
[_< back to root_](../../../)
