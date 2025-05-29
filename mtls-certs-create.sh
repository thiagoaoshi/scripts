#!/bin/bash
### MUTUAL TLS - Utilizando ambiente autoassinado ###
# cria pasta "certs" se nao existir
if [ ! -d "certs" ]; then
    mkdir "certs"
fi

# define a quantidade de bytes para a ser adotado no rsa
BYTES=4096
# nome do servidor com dominio (se nao necessitar remover o parametro -subj)
SERVIDOR=mtls.dominio.com.br
# Nome alternativo
DNSALTERNATIVO=autenticacao.dominio.com.br
# criando os certificados da autoridade (usar somente se nao ja existir uma)
openssl genrsa -out certs/ca.key $BYTES
openssl req -new -x509 -key certs/ca.key -out certs/ca.crt

# criando a chave privada e assinatura do servidor (Caso a aplicação servidor seja sua)
openssl req -new -newkey rsa:$BYTES \
    -sha256 -nodes \
    -keyout certs/server.key \
    -out certs/server.csr \
    -subj "/CN=$SERVIDOR"

# criando a chave privada e assinatura do Cliente (Caso seja de um parceiro, solicitar)
openssl req -new -newkey rsa:$BYTES \
    -sha256 -nodes \
    -keyout certs/client.key \
    -out certs/client.csr \
    -subj "/CN=$SERVIDOR"
# cria arquivo de parametro para adicionar ao certificado final com dns alternativo
echo "[server]
subjectAltName = DNS:$DNSALTERNATIVO" > certs/server.ext
echo "[client]
subjectAltName = DNS:$DNSALTERNATIVO" > certs/client.ext

# Cria o certificado publico do servidor com sua assinatura e reconhecido pela CA
openssl x509 -req -in certs/server.csr \
    -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial \
    -out certs/server.crt -days 365 -sha256 \
    -extfile certs/server.ext -extensions server
    
# Cria o certificado publico do cliente com sua assinatura e reconhecido pela CA
openssl x509 -req -in certs/client.csr \
    -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial \
    -out certs/client.crt -days 365 -sha256 \
    -extfile certs/client.ext -extensions client
