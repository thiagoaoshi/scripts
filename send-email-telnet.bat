@echo off
setlocal

rem Defina as variáveis de e-mail
set "email_de=seu_email@gmail.com"
set "senha=sua_senha"
set "email_para=destinatario@example.com"
set "assunto=Teste de e-mail via SMTP na porta 25"
set "corpo=Mensagem de teste enviada via SMTP na porta 25."

rem Defina o servidor SMTP e a porta
set "smtp_servidor=smtp.gmail.com"
set "smtp_porta=25"

rem Crie o arquivo de dados do e-mail
echo From: %email_de%> email.txt
echo To: %email_para%>> email.txt
echo Subject: %assunto%>> email.txt
echo.>> email.txt
echo %corpo%>> email.txt

rem Envie o e-mail via SMTP usando o utilitário 'telnet'
telnet %smtp_servidor% %smtp_porta%
timeout /t 5
echo HELO %smtp_servidor%> email_tmp.txt
echo AUTH LOGIN>> email_tmp.txt
echo %email_de%>> email_tmp.txt
echo %senha%>> email_tmp.txt
echo MAIL FROM: <%email_de%>> email_tmp.txt
echo RCPT TO: <%email_para%>> email_tmp.txt
echo DATA>> email_tmp.txt
type email.txt>> email_tmp.txt
echo.>> email_tmp.txt
echo QUIT>> email_tmp.txt
type email_tmp.txt | findstr /v /c:"220 " /c:"250 " /c:"354 " | telnet %smtp_servidor% %smtp_porta%
del email.txt email_tmp.txt

endlocal
