# Django Rest Framework database encryption example

## Goal

* Create data in postgres with encryption from django app
* Retrieve decrypted data via django app


## Technology used

* [PostgreSQL pgcrypto extension](https://www.postgresql.org/docs/9.6/pgcrypto.html)

   Provides utilities for encryption/decryption 


## Basic idea

* Encrypt on insert or update

    base table (`customer` in this example) stores encrypted data.

    client does not have to aware about encryption when performing insert or update.

    database trigger will encrypt privacy data and writes to database.

    encryption key will be taken from session variable. set it by `export PGOPTIONS="-c myproject.encrypt_key=XXXXX"`.

* Access decrypted data via view

    decription will be done by view (`customer_readable` in this example)

    decryption key will be taken from session variable. set it by `export PGOPTIONS="-c myproject.encrypt_key=XXXXX"`.

* This example uses common values for encrypting/decrypting.

* Django needs to swap models by HTTP method

    GET should use view.

    Other methods should use raw table (encrypted)

* why not encrypting at Django?

    because that way, sort and search won't work...

* SSL encryption on wire

    While data is encrypted inside the database, it is already decrypted when being transferred to client over the network. Enabling SSL to database connection ensures communication between database server and client is also encrypted.

    Do we need this?

    How much performance impact?

## How to run this example?

Start the container
```bash
# generate certificates
cd $REPO_ROOT/deploy/postgres/
./cert_gen.sh

# build and run docker containers
cd $REPO_ROOT/deploy/
docker-compose up --build -d

```

Try accessing `http://127.0.0.1:8000/customers/` from the browser


