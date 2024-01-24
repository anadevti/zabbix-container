# Instalação do zabbix 6.4.10. utilizando Docker.

 # Descrição:
Este script em shell, automatiza a instalação do zabbix server utilizando containers docker.

Pré requesitos:

- Docker Engine instalado (disponível em: https://docs.docker.com/engine/install/)
Conhecimentos básicos em Docker (Comandos básicos como: docker run, exec, pull, network)
- Contato minimo com o sistema zabbix
- Antes de realizar a execução do script é necessário criar um rede em modo bridge, para suportar os containers do zabbix:
- docker network create zabbix --subnet 172.16.0.0/29
##

Após o Download do script, execute-o com permissão de root (ou admin, no caso do windows):
sudo ./zabbix.docker-postegre.sh
##
Após execução do comando o docker criará 4 containers, responsável pela execução do módulos do zabbix

- Zabbix Server
- Zabbix Frontend
- Postgres Server
- Zabbix Trapper
- Agora é possível acessar a interface web do zabbix através do endereço:
127.0.0.1/zabbix
##

Assim temos um servidor zabbix totalmente funcional, ideal para ambiente de hologação e testes. Também sendo possível utilizar em ambientes menores, ou seja laboratórios gereais!

## REFERENCIAS:
https://www.zabbix.com/documentation/current/en/manual/installation/containers
