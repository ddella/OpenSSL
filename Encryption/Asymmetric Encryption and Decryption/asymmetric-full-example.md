# Asymmetric encryption by hand
This example is educational purposes ONLY. It shows all the steps to encrypt a file with a receiver's public key.  

Files used throughout this example:
>Original file to encrypt: `file.bin`
>Symmetric Key for encryption: `key.bin`
>Encrypted file: `file.bin.enc`
>Private Key: `rsa-key.pem`
>Public Key: `rsa-public-key.pem`
>Recipient Certificate: `rsa-crt.pem`

## Let's do a complete example of asymmetric encryption by hand.
Use this command to generate a self-signed certificate with the key pair:
[ECC self-signed certificate](https://gist.github.com/ddella/f6954409d2090908f6fec1fc3280d9d1)

>We need only one certificate, since we encrypt one file and send it to a receipient.
## Sender
### Files
```
Original file to encrypt: `file.bin`
Generate a random symmetric key for encryption: `key.bin`
Encrypted file: `file.bin.enc`
Download the recipient Certificate: rsa-crt.pem
Public Key extracted from certificate: `rsa-public-key.pem`
```

### Encrypt the file
Even with asymmetric encryption, we always do symmetrical encryption with a random key.  
The sender does the following:
1. generate a random key
2. encrypt the file with the random key
3. encrypt the random key with the recipient public key
4. sends the encrypted file and the encrypted symmetrical key

Use this command to generate a random symmetric key:
```shell
openssl rand -out key.bin 32
```

Use this command to extract the public key from the recipient's certificate:
```shell
openssl x509 -noout -pubkey -in rsa-crt.pem -out rsa-public-key.pem
openssl x509 -noout -pubkey -in ecc-crt.pem -out ecc-public-key.pem
```

Use this command to encrypt the file `file.bin`, with the key generated above, and save it as `file.bin.enc:
```shell
openssl enc -e -aes-256-cbc -p -md sha512 -salt -pbkdf2 -iter 100000 -pass file:./key.bin -in file.bin -out file.bin.enc
```

Use this command to encrypt the symmetric key `key.bin` with the recipient's public key:
```shell
openssl pkeyutl -encrypt -pubin -inkey rsa-public-key.pem -in key.bin -out key.bin.enc
```
At this point, you send the encrypted symmetric key `key.bin.enc` and the encrypted file `file.bin.enc` to the recipient.

## Recipient
### Files
```
Encrypted file: `file.bin.enc`
Encrypted symmetric key: `key.bin.enc`
Private Key: `rsa-key.pem`
```

### Decrypt the file
The recipient uses this command to decrypt the symmetric key `key.bin.enc` with his own private `rsa-key.pem`:
```shell
openssl pkeyutl -decrypt -inkey rsa-key.pem -in key.bin.enc -out key.bin1 
```

The recipient uses this command to decrypt the file `file.bin.enc` with the key `key.bin`:
```shell
openssl enc -d -aes-256-cbc -p -md sha512 -salt -pbkdf2 -iter 100000 -pass file:./key.bin -in file.bin.enc -out newfile.bin
```
## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Asymmetric-encryption-by hand)  
[_< back to encryption_](../)  
[_<< back to root_](../../../../)
