FROM postgres:9.6-alpine
RUN mkdir -p /etc/postgresql/

COPY [ "postgresql.conf", "/etc/postgresql/" ]
COPY [ "pg_hba.conf", "/etc/postgresql/" ]
COPY [ "server.crt", "/etc/postgresql/" ]
COPY [ "root.crt", "/etc/postgresql/" ]
COPY [ "server.key", "/etc/postgresql/" ]
RUN chown postgres.postgres /etc/postgresql/*

CMD ["-c","config_file=/etc/postgresql/postgresql.conf"]