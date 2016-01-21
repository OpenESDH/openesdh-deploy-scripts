rem @ECHO OFF

SET UPDATE_MARKER_FILE=C:\opene_updates\opene_ui\update.txt

IF NOT EXIST %UPDATE_MARKER_FILE% EXIT 1

rem Updating tenants' UI
cd c:\inetpub\visma_dk
git pull
call npm install
call gulp build

cd c:\inetpub\magenta_dk
git pull
call npm install
call gulp staff-install
call gulp staff build


cd c:\OpeneUI

git pull

call npm install
call bower update

del %UPDATE_MARKER_FILE%
call gulp all-modules-install

gulp --title="Visma OpenE" --logo "./app/assets/images/logo-opene.svg" all-modules build

rem copy additional files
copy C:\opene_update_scripts\custom\logo-opene.svg C:\OpeneUI\app\assets\images\logo-opene.svg

:ex
rem EXIT 0