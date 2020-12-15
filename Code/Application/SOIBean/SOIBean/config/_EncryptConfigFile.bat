@echo off
set Identity=%userdomain%\%username%
echo Identity: %Identity%
set CurrDrive=%~dp0
set Filter=%CurrDrive%*.config
echo File filter: %Filter%
call :ICACLS "%Filter%" "%Identity%"
GOTO EOF

:ICACLS
icacls "%~1" /grant %~2:F /T

for /f "tokens=*" %%a in ('dir /b *.config') do ( 

if /I NOT !%%a! == !Web.config! (
echo %%a

copy "%%a" Web.config /y
c:\windows\microsoft.net\framework\v4.0.30319\aspnet_regiis -pef connectionStrings . -prov DataProtectionConfigurationProvider
c:\windows\microsoft.net\framework\v4.0.30319\aspnet_regiis -pef credentialAppSettings . -prov DataProtectionConfigurationProvider
copy Web.config "%%a" /y
del Web.config
)

)

:EOF
REM pause
@echo on
