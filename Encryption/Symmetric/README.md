# Symmetric Encryption and Decryption
## List of supported ciphers
Use this command to list the supported ciphers:
```
openssl enc -ciphers
```
## Generate a dummy file
Generate a dummy file with random data and more than 1.5GB. See my other example about file size limitation with OpenSSL and CMS [here](../Asymmetric%20Encryption%20and%20Decryption/CMS.md#warning---file-size-limit)  
```shell
< /dev/urandom head -c 1610612733 > file.bin
```
>Looks like there's not size limitation for symmetrical encryption
## Encrypt
This is a type of encryption where only one secret key or password is used to encrypt and decrypt a file or data.  

Use this command to encrypt of a file with a symmetric key:
```shell
openssl enc -aes-256-cbc -e -salt -pbkdf2 -p -in file.bin -out file.bin.enc
```
>Use the option `-pass pass:mysecret` to specify the password on the command line

If you didn't specify the option `-pass pass:mysecret`, you will be asked for an encryption password and a confirmation.  
Output:
```
enter AES-256-CBC encryption password:
Verifying - enter AES-256-CBC encryption password:
salt=6F3BB1B46344EB65
key=9D568F122BDE781DA9F11173A3D74594886CCF718C6EE8CDC6CC51C50C78A460
iv =4BCE74C84549AA682343E9AC726F03A8
```
The options used on the command line:

    -aes-256-cbc        — the cipher
    -pbkdf2             - Use PBKDF2 algorithm
    -salt               - Use a randomly generated salt
    -pass pass:mysecret — the password in clear. The password is: mysecret (see Passphrase options below)
    -P                  — Print out the salt, key and IV used (see last three lines of output above)
    -in file            — file to encrypt
    -out file           — encrypted file
## Decrypt
Use this command to decrypt of a file with a symmetric key:
```shell
openssl enc -aes-256-cbc -d -salt -pbkdf2 -in file.bin.enc -out new-file.bin
```
>Use the option `-pass pass:mysecret` to specify the password on the command line

The command will ask for the decryption password used to encrypt the file:  
```
enter AES-256-CBC decryption password:
```
## Passphrase options
Several OpenSSL commands accept password arguments for input and output passwords respectively. These allow the password to be obtained from a variety of sources. If no password argument is given and a password is required then the user is prompted to enter one from the current terminal with echoing turned off.

The `-pass` option can take the following arguments:

    pass:password
        The actual password is password. This form should only be used where security is not important.
    env:var
        Obtain the password from the environment variable `var`. This option should be used with caution.
    file:pathname
        The first line of pathname is the password.
    fd:number
        Read the password from the file descriptor number. This can be used to send the data via a pipe for example.
    stdin
        Read the password from standard input.

## Verification
The file `new-file.bin` should be a copy of the original file `file.bin`. We'll do a simple digest on the two files and make sure all hash values are identical.  

```
% openssl dgst -sha256 file.bin 
SHA2-256(file.bin)= 7976f1fedef9adc6095e21e8d2869b53f323c29c0053e111a9290f8c9c8569d4

% openssl dgst -sha256 new-file.bin
SHA2-256(new-file.bin)= 7976f1fedef9adc6095e21e8d2869b53f323c29c0053e111a9290f8c9c8569d4
```
## Full example
Following is a full example on how to encrypt and decrypt a file with symmetric key.  

Use this command to generate a random key of 256 bit:
```shell
openssl rand -out key.bin 32
```

Use this command to encrypt the file `file.bin` with the key generated above and save it as `file.bin.enc`:
```shell
openssl enc -e -aes-256-cbc -p -md sha512 -salt -pbkdf2 -iter 100000 -pass file:./key.bin -in file.bin -out file.bin.enc
```

Use this command to decrypt the file `file.bin.enc` with the key same key used to encrypt:
```shell
openssl enc -d -aes-256-cbc -p -md sha512 -salt -pbkdf2 -iter 100000 -pass file:./key.bin -in file.bin.enc -out newfile.bin
```

### Optional
Use this command to verify that the new decrypted file is identical to the original one:
```shell
openssl dgst -sha256 file.bin 
openssl dgst -sha256 newfile.bin
```

Output:
```
SHA2-256(file.bin)= 1c885a76546d19bc10983be0158b02352d77f53d8d90c8d4b94017eefdcccaf1
SHA2-256(newfile.bin)= 1c885a76546d19bc10983be0158b02352d77f53d8d90c8d4b94017eefdcccaf1
```
## Encrypted file format
**This section is INCOMPLETE**  

The only thing OpenSSL saves in the encrypted file is a 16 octets header:
  * The string 'Salted__' `0x5361 6c74 6564 5f5f`
  * An 8 octets randomised "Salt" `0xdb64 819f 64a7 8751`
  * The encrypted data  

>The other options, like the password used to encrypt the file, are *assumed* to be known by both parties.

### Example
A simple text `file.txt`:
```
1st line
2nd line
3rd line
```

Use this command to `null` encrypt the text file (no encryption):
```shell
openssl enc -null -e -pbkdf2 -p -pass pass:mysecret -in file.txt -out file.null.enc
```
>The `-p` option prints the salt value

Output:
```
salt=DB64819F64A78751
```

Use this command to view the encrypted file:
```shell
xxd file.null.enc
```

Output:
```
00000000: 5361 6c74 6564 5f5f db64 819f 64a7 8751  Salted__.d..d..Q
00000010: 3173 7420 6c69 6e65 0a32 6e64 206c 696e  1st line.2nd lin
00000020: 650a 3372 6420 6c69 6e65 0a              e.3rd line.
```
## License
This project is licensed under the [MIT license](/LICENSE).  

[_^ back to top of page_](#Symmetric-Encryption-and-Decryption)  
[_< back to encryption_](../)  
[_<< back to root_](../../../../)
