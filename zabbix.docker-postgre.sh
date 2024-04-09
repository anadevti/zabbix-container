#!/bin/bash

# Criar a rede zabbix se não existir
sudo docker network create zabbix

# Iniciar o contêiner do PostgreSQL
sudo docker run --name postgres-server -t \
      -e POSTGRES_USER="zabbix" \
      -e POSTGRES_PASSWORD="zabbix_pwd" \
      -e POSTGRES_DB="zabbix" \
      --network=zabbix \
      --restart unless-stopped \
      -d postgres:latest

# Iniciar o contêiner de SNMP traps
sudo docker run --name zabbix-snmptraps -t \
      -v /zbx_instance/snmptraps:/var/lib/zabbix/snmptraps:rw \
      -v /var/lib/zabbix/mibs:/usr/share/snmp/mibs:ro \
      --network=zabbix \
      -p 162:162/udp \
      --restart unless-stopped \
      -d zabbix/zabbix-snmptraps:alpine-6.4-latest

# Iniciar o contêiner do Zabbix Server
sudo docker run --name zabbix-server-pgsql -it \
      -e DB_SERVER_HOST="postgres-server" \
      -e POSTGRES_USER="zabbix" \
      -e POSTGRES_PASSWORD="zabbix_pwd" \
      -e POSTGRES_DB="zabbix" \
      -e ZBX_ENABLE_SNMP_TRAPS="true" \
      -e ZBX_STARTPOLLERS="20" \
      -e ZBX_STARTPINGERS="20" \
      -e ZBX_CACHESIZE="64M" \
      -e ZBX_HISTORYCACHESIZE="32M" \
      -e ZBX_HISTORYINDEXCACHESIZE="16M" \
      -e ZBX_TRENDCACHESIZE="16M" \
      -e ZBX_VALUECACHESIZE="32M" \
      -e ZBX_ADMIN_PASSWORD="admin" \
      --network=zabbix \
      -p 10051:10051 \
      --volumes-from zabbix-snmptraps \
      --restart unless-stopped \
      -d zabbix/zabbix-server-pgsql:alpine-6.4-latest

# Iniciar o contêiner do Zabbix Web com Nginx
sudo docker run --name zabbix-web-nginx-pgsql -t \
      -e ZBX_SERVER_HOST="zabbix-server-pgsql" \
      -e DB_SERVER_HOST="postgres-server" \
      -e POSTGRES_USER="zabbix" \
      -e POSTGRES_PASSWORD="zabbix_pwd" \
      -e POSTGRES_DB="zabbix" \
      -e ZBX_ADMIN_PASSWORD="admin" \
      --network=zabbix \
      -p 443:8443 \
      -p 80:8080 \
      -v /etc/ssl/nginx:/etc/ssl/nginx:ro \
      --restart unless-stopped \
      -d zabbix/zabbix-web-nginx-pgsql:alpine-6.4-latest
