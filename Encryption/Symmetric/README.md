# Symmetric Encryption and Decryption
## List of supported ciphers
Use this command to list the supported ciphers:
```
openssl enc -ciphers
```
## Generate a dummy file
Generate a dummy file with random data and more than 1.5GB. See my other example aboput file size limitation [here](../Asymmetric%20Encryption%20and%20Decryption/CMS.md#warning---file-size-limit)  
```shell
< /dev/urandom head -c 1610612733 > file1.bin
```
>Looks like there's not size limitation for symmetrical encryption
## Encrypt
This is a type of encryption where only one secret key or password is used to encrypt and decrypt a file or data.  

Use this command to encrypt of a file with a symmetric key:
```shell
openssl enc -aes-256-cbc -e -salt -pbkdf2 -in file.bin -out file.bin.enc
```

The command will ask for an encryption password and a confirmation:  
```
enter AES-256-CBC encryption password:
Verifying - enter AES-256-CBC encryption password:
```
Let’s find out each part in our code

    -aes-256-cbc — the cipher name( symmetric cipher : AES ;block to stream conversion : CBC(cipher block chaining))
    -pass pass:<password> — to specify the password (here password is kekayan)
    -P — Print out the salt, key and IV used.
    -in file— input file /input file absolute path(here image.png)
    -out file— output file /output file absolute path(here file.enc)

## Decrypt
Use this command to decrypt of a file with a symmetric key:
```shell
openssl enc -aes-256-cbc -d -salt -pbkdf2 -in file.bin.enc -out new-file.bin
```
>Use the `-kfile mypass` parameter to read the password from a file, for either encryption/decryption  

The command will ask for the decryption password used to encrypt the file:  
```
enter AES-256-CBC decryption password:
```
## Verification
The file `new-file.bin` should be a copy of the original file `file.bin`. We'll do a simple digest on the two files and make sure all hash values are identical.  

```
% openssl dgst -sha256 file.bin 
SHA2-256(file.bin)= 7976f1fedef9adc6095e21e8d2869b53f323c29c0053e111a9290f8c9c8569d4

% openssl dgst -sha256 new-file.bin
SHA2-256(new-file.bin)= 7976f1fedef9adc6095e21e8d2869b53f323c29c0053e111a9290f8c9c8569d4
```
## More
More symmetric encryption/decryption options:
```shell
openssl enc -e -kfile mypass -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in file.txt -out file.enc
```

```shell
openssl enc -d -kfile mypass -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in file.enc -out file.txt
```
## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Symmetric-Encryption-and-Decryption)  
[_< back to encryption_](../)  
[_<< back to root_](../../../../)
