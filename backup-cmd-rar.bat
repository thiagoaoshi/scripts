## script de backup simples, que cria o backup em um zip e limpa os backups com mais de 30 dias

REM BACKUP do WWWROOT
REM setando data no formato brasileiro
set databr=%date:~0,2%-%date:~3,2%-%date:~6,10%

rem compacta a pasta gerada
rar a -r "C:\backup-wwwroot\wwwroot-%databr%.rar" "C:/inetpub/wwwroot"

REM apaga arquivos com mais de 30 dias
start FORFILES /S /p "C:\backup-wwwroot\" /d -30 /c "CMD /C DEL @FILE /Q"
