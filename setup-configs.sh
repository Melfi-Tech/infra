if [ -z ${1+x} ]; then echo "config destinations not provided" && exit 1; fi

postgres_compose=$1/pg_compose.yml

# Setup postgres data
cat << EOF >> $postgres_compose
version: "3.8"
services:
  db:
    image: postgres
    container_name: local_pgdb
    restart: always
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: $PG_USER
      POSTGRES_PASSWORD: $PG_PASS
    volumes:
      - local_pgdata:/var/lib/postgresql/data
  bytebase:
    image: bytebase/bytebase:2.16.0
    container_name: bytebase
    restart: always
    ports:
      - "8888:8080"
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@melfi.com
      PGADMIN_DEFAULT_PASSWORD: $PG_PASS
    volumes:
      - bytebase-data:/var/opt/bytebase

volumes:
  local_pgdata:
  bytebase-data:
EOF

# Setup nginx configuration
cat << EOF >> /etc/nginx/sites-enabled/default

server {
  server_name api.usemelon.co;

  location / {
    proxy_set_header Host "api.usemelon.co";
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_pass  http://127.0.0.1:5050;
  }
}

server {
  server_name api.staging.usemelon.co;

  location / {
    proxy_set_header Host "api.staging.usemelon.co";
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_pass  http://127.0.0.1:5051;
  }
}

server {
  server_name admin.usemelon.co;

  location / {
    proxy_set_header Host "admin.usemelon.co";
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_pass  http://127.0.0.1:4173;
  }
}
EOF

ufw allow 8888
ufw allow 5432

