# Symmetric Encryption and Decryption
This is a type of encryption where only one secret key or password is used to encrypt and decrypt a file or any electronic information.  

Use this command to encrypt of a file with a symmetric key:
```shell
openssl enc -aes-256-cbc -e -salt -pbkdf2 -in file.txt -out file.enc
```

Use this command to decrypt of a file with a symmetric key:
```shell
openssl enc -aes-256-cbc -d -salt -pbkdf2 -in file.enc -out file.txt
```
>Use the `-kfile mypass` parameter to read the password from a file, for either encryption/decryption  

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
