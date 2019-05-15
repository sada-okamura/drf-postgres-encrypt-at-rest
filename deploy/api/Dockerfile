FROM python:alpine3.7

RUN apk --update add postgresql-client libpq make && rm -rf /var/cache/apk/*
ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code

RUN apk update \
  && apk add --virtual build-deps gcc python3-dev musl-dev \
  && apk add postgresql-dev \
  && pip install -U pip \
  && pip install psycopg2 \
  && apk del build-deps


RUN mkdir /root/.postgresql

COPY [ "postgresql.crt", "/root/.postgresql/" ]
COPY [ "root.crt", "/root/.postgresql/" ]
COPY [ "postgresql.key", "/root/.postgresql/" ]

CMD ["/code/docker-entrypoint.sh"]
