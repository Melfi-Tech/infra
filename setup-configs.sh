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
  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin4_container
    restart: always
    ports:
      - "8888:80"
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@melfi.com
      PGADMIN_DEFAULT_PASSWORD: $PG_PASS
    volumes:
      - pgadmin-data:/var/lib/pgadmin

volumes:
  local_pgdata:
  pgadmin-data:
EOF