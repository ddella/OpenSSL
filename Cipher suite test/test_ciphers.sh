#!/bin/bash

# From: https://superuser.com/questions/109213/how-do-i-list-the-ssl-tls-CIPHER-suites-a-particular-website-offers
# From: https://gist.github.com/commenthol/194ea40f6e3cabb458f73dc64fc46aac

# Shell script to test CIPHER suites on a TLS server. Gets a list of supported CIPHER suites from OpenSSL and tries
# to connect to a server using each one. If the handshake is successful, it prints YES. If the handshake isn't successful,
# it prints NO, followed by the OpenSSL error text.

# Tested with TLS 1.2 and TLS 1.3. Works with 'bash' and 'zsh' on both macOS and Linux.
# Make sure you have the 'chain of trust' in the file 'chaim.pem'. This is ALL the certificates (RootCA, SubRootCA and server)
# in a PEM file to avoid the anoying error: '21 (unable to verify the first certificate)'
# If the file 'chaim.pem' is supplied, you will get: 'Verify return code: 0 (ok)'

# Example of the OpenSSL command to test a cipher against a server:
#   openssl s_client -cipher ECDHE-ECDSA-AES256-CCM8 -tls1_2 -CAfile chain.pem -connect localhost:8443 <<< /dev/null
#   openssl s_client -ciphersuites TLS_AES_256_GCM_SHA384 -tls1_3 -CAfile chain.pem -connect localhost:8443 <<< /dev/null
#         -cipher <value>          Specify TLSv1.2 and below cipher list to be used
#         -ciphersuites <value>    Specify TLSv1.3 ciphersuites to be used

if [ $# -ne 2 ]; then
  printf "\nERROR: Usage: %s <server:port> <TLS version>, ex.: www.example.com:8443 tls1_3 \n" $(basename ${0})
  printf "       If no TCP port is specified, TCP/443 will be used.\n"
  printf "       TLS version: Only 'tls1_2' or 'tls1_3' is supported.\n\n"
  exit 1
fi

SERVER=$1
PORT=$(cut -f2 -s -d ":" <<< ${SERVER})
if [ -z "$PORT" ]; then
  SERVER="$SERVER:443"
fi

TLS="-$2"
if [[ $TLS == '-tls1_2' || $TLS == '-tls1_3' ]]; then
  # The cipher argument changed in OpenSSL between TLS 1.2 and TLS 1.3 :-(
  if [[ $TLS == '-tls1_2' ]]; then
    CIPHERARG='-cipher'
  fi
  if [[ $TLS == '-tls1_3' ]]; then
    CIPHERARG='-ciphersuites'
  fi
else
  printf "Invalid TLS version (%s), only tls1_2 or tls1_3 is supported.\n" ${TLS}
  exit 1
fi

printf "checking server '%s' with TLS version '%s'\n\n" "${SERVER}" "${TLS}"
CIPHERS=$(openssl ciphers -s "$TLS" 'ALL:eNULL' | sed -e 's/:/ /g')

for CIPHER in ${CIPHERS[@]}
do
  printf "Testing %s..." "${CIPHER}"
  RESULT=$(openssl s_client "$CIPHERARG" "$CIPHER" "$TLS" -CAfile chain.pem -connect "$SERVER" 2>&1 <<< /dev/null)
  if [[ "$RESULT" =~ ":error:" ]] ; then
    error=$(cut -f6 -s -d ":" <<< ${RESULT})
    printf "NO (%s)\n" "${error}"
  else
    SERVER_CIPHER=$(sed -rn 's/^.*Cipher is ([A-Z0-9_\-]+).*$/\1/p' <<< ${RESULT})
    if [[ $CIPHER == $SERVER_CIPHER ]] ; then
      printf "YES\n"
    else
      printf "UNKNOWN (Testing '%s' received '%s')\n" $CIPHER $SERVER_CIPHER
    fi
  fi
done
