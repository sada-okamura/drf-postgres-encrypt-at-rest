create database myproject;

do
$do$
begin
   if not exists (select from pg_catalog.pg_roles where  rolname = 'myprojectuser') then
      create role myprojectuser login password 'password';
   end if;
end
$do$;

alter role myprojectuser set client_encoding to 'utf8';
alter role myprojectuser set default_transaction_isolation to 'read committed';
alter role myprojectuser set timezone to 'utc';
grant all privileges on database myproject to myprojectuser;

\c myproject
create extension if not exists pgcrypto;
set role myprojectuser;

-- *****************************************************************************************
-- this is the base table and stores encrypted data
-- Database client must have a proper encryption key to insert/update customer table record
-- export PGOPTIONS="-c myproject.encrypt_key=XXXXX"
-- *****************************************************************************************

create table if not exists customer (
    "id" serial not null primary key,
    "first_name" varchar(256) not null,
    "last_name" varchar(256) not null
);

-- trigger to encrypt privacy protected fields
create or replace function encrypt_customer_privacy() returns trigger
as $$
declare
    v_encrypt_key text;
begin
    select current_setting('myproject.encrypt_key') into v_encrypt_key;
    if not found then
        raise exception 'variable myproject.encrypt_key is not set';
    end if;
    new.first_name = pgp_sym_encrypt(new.first_name::text, v_encrypt_key, 'compress-algo=1, cipher-algo=aes256');
    new.last_name = pgp_sym_encrypt(new.last_name::text, v_encrypt_key, 'compress-algo=1, cipher-algo=aes256');
    return new;
end
$$ language plpgsql;

drop trigger if exists encrypt_customer_privacy on customer;
create trigger encrypt_customer_privacy
before insert or update of first_name, last_name on customer
for each row execute procedure encrypt_customer_privacy();

-- *****************************************************************************************
-- view that returns decrypted data
-- Database client must have a proper encryption key to query from this view
-- export PGOPTIONS="-c myproject.encrypt_key=XXXXX"
-- *****************************************************************************************
create or replace view customer_readable as
select
    id,
    pgp_sym_decrypt(first_name::bytea, ekey::text) first_name,
    pgp_sym_decrypt(last_name::bytea, ekey::text) last_name
from customer, (select current_setting('myproject.encrypt_key')::text as ekey) encrypt;
