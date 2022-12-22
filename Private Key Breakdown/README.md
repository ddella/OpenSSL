# OpenSSL RSA Private Key Breakdown
This applies to RSA private key only.  
Based on [RSA Private Key Breakdown](http://etherhack.co.uk/asymmetric/docs/rsa_key_breakdown.html)
## RSA Private Key in PEM
The first thing to do is to convert the private key `PEM`file to HEX. The `PEM` file is the base64 representation of the key. For this example, I generated a 512-bit RSA private key.
>RSA Private Key in Base64 Format (PEM)
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

## RSA Private Key in Hexadecimal
Convert the private key `PEM` file to hexadecimal.  
Check my script `pem2hex.sh` on my Gist [here](https://gist.github.com/ddella/d07d5b827f3638e727bbf3dc1210d4a2) to convert a `PEM` format file to hexadecimal format.
```shell
./pem2hex.sh private-key.pem
```
```
30 82 01 54 02 01 00 30 0d 06 09 2a 86 48 86 f7 0d 01 01 01 05 00 04 82 01 
3e 30 82 01 3a 02 01 00 02 41 00 cb e3 17 32 e9 0c 8c 8d 22 d6 52 97 45 5b 
f1 66 71 4d b5 24 7e 28 e9 60 dc 3d f0 a9 e2 10 6d 0a 21 5e 07 1d 16 b9 94 
50 ca 03 54 fa e7 7c 57 22 72 3c 45 b6 50 55 a9 69 13 6e 2f 31 47 57 ff c9 
02 03 01 00 01 02 40 7c a6 3a b1 aa 5f 3c b2 b0 c0 bd 3f b4 6c d0 ba 23 bd 
31 68 bd 24 c0 01 b2 c4 bf 94 ed 1b c3 bd 1d 47 e6 e3 1c 9d 82 38 f7 67 49 
8e d8 ad 7b cc cc ec 67 a1 be b2 9a 21 44 25 13 f4 fa 59 af 71 02 21 00 eb 
f4 f4 fe a4 ca 5e 4c 38 a4 31 7c 23 cf 2f ee a3 3d 1f 48 52 c9 40 1f 2f 61 
0e 15 c5 43 50 85 02 21 00 dd 34 c1 0e cd 04 2b 3f b4 04 e8 c3 8e 71 ed 7c 
6c ba 5c 00 c1 c2 f8 79 40 c0 5c 7b 9b 8b 57 75 02 20 4e fe da 8a ea 36 ca 
2d 30 85 5f ff d4 a9 47 bd d8 2e dd 6b 44 34 16 60 9a 67 1e e5 10 fe c1 55 
02 20 48 0f 18 58 de f6 5d b4 59 cb 43 9b f8 ba 2a 37 df 1f 72 3b 18 e3 8f 
97 c8 3d 21 a3 6e 8f 1c c5 02 21 00 dd 19 c8 60 2e 9a dc 5b cf cf cd a1 5d 
9f 18 42 09 ae cc 03 73 1b 10 79 bb c4 2f 2f bb f6 a7 88
```
## RSA Private Key in Hexadecimal
Representation of an RSA 512-bit private key in hexadecimal.  
![Alt text](/images/rsa-priv-key-hex.jpg "RSA Private key in hex format")
