#!/bin/bash
### Script para validar status coe via curl logando a hora caso codigo 200 nao seja sucesso, e executando comando escalar o serviço docker para 0 e depois para 1 (uma forma de restart)

status_code=$(curl --write-out %{http_code} --silent --output /dev/null https://site.com.br)
if [[ "$status_code" -ne 200 ]] ; then
echo "Status do Site alterado para: $status_code" | docker service scale SERVICE-NAME=0; docker service scale SERVICE-NAME=1
else
  date >> health-date.log; exit 0
fi
