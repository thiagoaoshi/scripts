#!/bin/bash

# Define os arquivos de entrada e saída
DOMAINS_FILE="lista.txt"
OUTPUT_FILE="certificados_expiracao.txt"

# Limpa o arquivo de saída antes de cada execução
> "$OUTPUT_FILE"

# Verifica se o arquivo de domínios existe
if [ ! -f "$DOMAINS_FILE" ]; then
    echo "O arquivo '$DOMAINS_FILE' não foi encontrado."
    exit 1
fi

echo "Iniciando a verificação de certificados..."
echo "----------------------------------------"

# Lê cada linha do arquivo de domínios
while read -r domain; do
    # Ignora linhas em branco ou que começam com '#'
    if [[ -z "$domain" || "$domain" =~ ^#.* ]]; then
        continue
    fi

    echo "Verificando certificado para: $domain"

    # Usa o 'openssl' para obter a data de expiração do certificado
    # O timeout de 5 segundos evita que o script trave em domínios inacessíveis
    EXPIRATION_DATE=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

    # Verifica se a data foi obtida com sucesso
    if [ -z "$EXPIRATION_DATE" ]; then
        echo "  -> Não foi possível obter a data de expiração. Possível problema com o domínio ou conexão."
        echo "Domínio: $domain - Erro ao obter a data de expiração" >> "$OUTPUT_FILE"
    else
        # Converte a data de expiração para um formato mais legível
        EXPIRATION_TIMESTAMP=$(date -d "$EXPIRATION_DATE" +"%s")
        CURRENT_TIMESTAMP=$(date +"%s")

        # Calcula a diferença de dias
        DAYS_LEFT=$(( (EXPIRATION_TIMESTAMP - CURRENT_TIMESTAMP) / 86400 ))

        echo "  -> Data de Expiração: $EXPIRATION_DATE"
        echo "  -> Dias Restantes: $DAYS_LEFT"

        # Adiciona o domínio e a data de expiração ao arquivo de saída
        echo "Domínio: $domain - Expira em: $EXPIRATION_DATE" >> "$OUTPUT_FILE"
    fi

    echo "---"

done < "$DOMAINS_FILE"

echo "Verificação concluída. Os resultados foram salvos em '$OUTPUT_FILE'."
