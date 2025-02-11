rem variavel: caminho onde deve-se criptografar os arquivos
set dir_encrypt=\\servidor\pasta_arquivos_SEM_criptografia\

rem variavel: caminho destino dos arquivos que forem criptografados
set dir_dest_encrypt=\\servidor\pasta_arquivos_criptografados\

rem variavel: caminho onde deve-se DEScriptografar os arquivos .gpg
set dir_decrypt=\\servidor\pasta_arquivos_COM_criptografia_a_ser_descriptografados\

rem variavel: caminho destino dos arquivos que forem DEScriptografados
set dir_dest_decrypt=\\servidor\pasta_arquivos_removido_a_criptografia\

rem variavel: senha da chave privada
set passgpg=senha

rem se nao existir arquivos a serem criptografados seguir proxima tarefa
if not exist %dir_encrypt%*.txt goto decrypt
gpg --batch --encrypt-files -r "Nome-certificado-privado" "%dir_encrypt%\*.txt"
move %dir_encrypt%*.gpg %dir_dest_encrypt%

:decrypt
if not exist %dir_decrypt%*.gpg goto fim
gpg --batch --pinentry-mode loopback --passphrase %passgpg% --decrypt-files "%dir_decrypt%*.gpg"
move %dir_decrypt%*.txt %dir_dest_decrypt%

:fim
exit
