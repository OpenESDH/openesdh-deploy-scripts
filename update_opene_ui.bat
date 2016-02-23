rem @ECHO OFF

SET UPDATE_MARKER_FILE=C:\opene_updates\opene_ui\update.txt

IF NOT EXIST %UPDATE_MARKER_FILE% EXIT 1

cd c:\OpeneUI

call git pull

call npm install
call bower update

del %UPDATE_MARKER_FILE%
call gulp all-modules-install

call gulp --title="Visma case" --logo "./app/assets/images/VismaCase.svg" all-modules build

rem copy additional files
copy C:\opene_update_scripts\custom\VismaCase.svg C:\OpeneUI\app\assets\images\VismaCase.svg


rem Updating tenants' UI
cd c:\inetpub\visma_dk
call git pull
call npm install
call gulp build

cd c:\inetpub\magenta_dk
call git pull
call npm install
call gulp staff-install
call gulp staff build


:ex
rem EXIT 0