# OpenSSL Utilities
## Generate pseudo-random bytes
```shell
openssl rand -base64 32
```

```shell
openssl rand -hex 32
```

## Encode to base64
### Encode a string
```shell
openssl enc -base64 <<< "Hello, World!"
```
### Encode a file
```shell
openssl enc -base64 -in text.plain -out text.base64
```

## Decode from base64
```shell
openssl enc -base64 -d <<< SGVsbG8sIFdvcmxkIQo=
```

```shell
openssl enc -d -base64 -in text.base64 -out text.plain
```

## Generate prime number
```shell
openssl prime -generate -safe -bits 64
```

## Test if a number is prime
```shell
openssl prime 17
```

## Generate a random password
```shell
head -c 20 /dev/urandom | openssl enc -base64
```

## Create an MD5/SHA1/SHA256 digest
```shell
openssl dgst -md5 filename
```

```shell
openssl dgst -sha1 filename
```

```shell
openssl dgst -sha256 filename
```

## Create an HMAC-MD5 on a file:
```shell
cat file.bin | openssl dgst -md5 -hmac 'secret'
```

## To get the list of all the hash supported
```shell
openssl dgst -list
```

## dgst requires a file. You can simulate a file with “<<<”
```shell
openssl dgst -md5 <<<"This is a text"
```

## Print the digest with separating colons
```shell
openssl dgst -sha3-512 -c <<<"This is a text"
```
