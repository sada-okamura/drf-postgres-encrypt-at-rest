#!/bin/bash

rm ./*.crt
rm ./*.csr
rm ./*.key

# ------------------------------------
# Server Private Key
# ------------------------------------
# generate rsa key for postgres server
openssl genrsa -des3 -out server.key 2048
# remove passphrase from the private key
openssl rsa -in server.key -out server.key
chmod 400 server.key


# ------------------------------------
# Server Certificate
# ------------------------------------
openssl req -new -key server.key -days 3650 -out server.crt -x509 \
    -subj '/C=AU/ST=VICTORIA/L=MELBOURNE/O=mycompany/CN=postgres/emailAddress=support@mycompany.com'

# ------------------------------------
# Root Certificate
# ------------------------------------
# create root certificate as a copy of server certificate (we will use it to create self-signed certificates!)
cp server.crt root.crt



# ------------------------------------
# Client Private Key
# ------------------------------------
openssl genrsa -des3 -out postgresql.key 2048
openssl rsa -in postgresql.key -out postgresql.key
chmod 400 postgresql.key


# ------------------------------------
# Client CSR
# ------------------------------------
openssl req -new -key postgresql.key -out postgresql.csr \
    -subj '/C=AU/ST=VICTORIA/L=MELBOURNE/O=mycompany/CN=postgres'


# ------------------------------------
# Sign CSR with root.crt
# ------------------------------------
openssl x509 -req -in postgresql.csr -CA root.crt -CAkey server.key -out postgresql.crt -CAcreateserial

mv postgresql.crt ../api/
mv postgresql.key ../api/
cp root.crt ../api/
