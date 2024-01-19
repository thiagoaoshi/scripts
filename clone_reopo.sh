# primeiramente gerar o par de chaves ssh na maquina local:
# ssh-keygen -t ed25519 -C "your_email@example.com"

# Adicionar a kay ssh ao agente do ssh
#  eval "$(ssh-agent -s)"
#  ssh-add ~/.ssh/id_ed25519

#  Adicionar a pub key gerada na conta do repositorio git em questao.

#!/bin/bash
# Clone repositorio privado usando ssh
git clone git@github.com:your_username/your_repository.git

# formas de conectar/autenticar no git:
# ssh-agent bash -c 'ssh-add /somewhere/yourkey; git clone git@github.com:user/project.git'
# ssh-agent $(ssh-add /somewhere/yourkey; git clone git@github.com:user/project.git)
# GIT_SSH_COMMAND='ssh -i private_key_file -o IdentitiesOnly=yes' git clone user@host:repo.git