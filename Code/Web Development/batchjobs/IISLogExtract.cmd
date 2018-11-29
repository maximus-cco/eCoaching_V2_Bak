@ECHO OFF

FOR /F "TOKENS=1-4 DELIMS=/ " %%A IN ('DATE/T') DO SET DATE=%%D-%%B-%%C
FOR /F "TOKENS=1-4 DELIMS=:. " %%A IN ('echo %TIME%') DO SET TIME=%%A:%%B:%%C
ECHO Start: %DATE% %TIME%

REM Set IIS Log files location (input)
SET IIS_LOG_DIR=c:\inetpub\logs\LogFiles\W3SVC2\
REM SET IIS_LOG_DIR=D:\Apps\logs\

REM Set Target (URL) to parse
REM SET WEB_ROOT=/eCoachingLog_st/
SET WEB_ROOT=/eCoachingLog/

REM Set Parsed CSV files location (web server)
SET CURRENT_DIR=%~dp0out\

REM Set CSV files processing location (db server)
REM Dev 
REM SET COPY_CSV_TO_DIR=\\f3420-ecldbd01\Data\Coaching\IISLogImport
REM ST
REM SET COPY_CSV_TO_DIR=\\f3420-ecldbt01\Data\Coaching\IISLogImport
REM Prod
SET COPY_CSV_TO_DIR=\\f3420-ecldbp01\Data\Coaching\IISLogImport

REM Get previous day iis log file name
FOR /F %%A IN ('cscript //nologo yesterdayDate.vbs') DO SET yesterday=%%A
SET iisFileName=u_in%yesterday:~2,6%.log
SET iisFileNameFullPath=%IIS_LOG_DIR%%iisFileName%
ECHO IIS file: %iisFileNameFullPath%

REM Set output csv file name
SET csvFileName=ecl_iis_%yesterday:~2,6%.csv
SET csvFileNameFullPath=%CURRENT_DIR%%csvFileName%
ECHO CSV file: %csvFileNameFullPath%

REM Extract ecl user web activities to cvs file
"C:\Program Files (x86)\Log Parser 2.2\logparser" ^
"SELECT EXTRACT_SUFFIX(UserName, 0, '\\') AS UserName, TO_TIMESTAMP(Date, Time) AS DateTime, EXTRACT_SUFFIX(Target, 0, '%WEB_ROOT%') AS Target, EXTRACT_TOKEN(Target, 2, '/') AS PageName,StatusCode INTO %csvFileNameFullPath% ^
 FROM %iisFileNameFullPath% ^
 WHERE Target LIKE '%WEB_ROOT%%%' ^
   AND UserName IS NOT NULL ^
   AND Target NOT LIKE '%WEB_ROOT%%%KeepSessionAlive%%' ^
   AND Target NOT LIKE '%WEB_ROOT%%%Scripts/%%' ^
   AND Target NOT LIKE '%WEB_ROOT%Content/%%' ^
   AND Target NOT LIKE '%WEB_ROOT%fonts/%%' ^
   AND Target NOT LIKE '%WEB_ROOT%bundles/%%' ^
   AND Target NOT LIKE '%WEB_ROOT%Error' ^
   AND PageName IS NOT NULL ^
   AND StatusCode = 200" -i:IIS -o:CSV 

XCOPY /D /Y %csvFileNameFullPath% %COPY_CSV_TO_DIR%
DEL %csvFileNameFullPath% 

FOR /F "TOKENS=1-4 DELIMS=/ " %%A IN ('DATE/T') DO SET DATE=%%D-%%B-%%C
FOR /F "TOKENS=1-4 DELIMS=:. " %%A IN ('echo %TIME%') DO SET TIME=%%A:%%B:%%C
ECHO Finish: %DATE% %TIME%