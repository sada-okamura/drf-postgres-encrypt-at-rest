#!/bin/sh

psql sslmode=verify-full  -f setup.sql
pip3 install -r requirements.txt
python3 manage.py migrate
python3 manage.py runserver "0.0.0.0:8000"