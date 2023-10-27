REM backup de base de dados mySQL utilizando dump no windows e zipando

@echo off
 
set dbUser=root
set dbPassword=senha
set database
set backupDir="D:\BACKUP-MYSQL"
set mysqldump="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe"
set mysqlDataDir="C:\ProgramData\MySQL\MySQL Server 8.0\Data"
set zip="C:\Program Files\7-Zip\7z.exe"
 
:: get date
for /F "tokens=1-3 delims=/ " %%i in ('date /t') do (
set dd=%%i
set mm=%%j
set yy=%%k
)
 
:: get time
for /F "tokens=1-2 delims=:. " %%i in ('time /t') do (
set hh=%%i
set mi=%%j
)
 
set dirName=%dd%%mm%%yy%_%hh%%mi%
 
if not exist %backupDir%\%dirName%\ mkdir %backupDir%\%dirName%

%mysqldump% --host="localhost" --user=%dbUser% --password=%dbPassword% %database% > %backupDir%\%dirName%\MySQL_%database%.sql

%zip% a -tgzip %backupDir%\%dirName%\MySQL_%database%.sql.gz %backupDir%\%dirName%\MySQL_%database%.sql
 
del %backupDir%\%dirName%\MySQL_%database%.sql
