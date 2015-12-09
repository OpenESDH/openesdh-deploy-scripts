rem @ECHO OFF

SET UPDATE_MARKER_FILE=C:\opene_updates\opene_ui\update.txt

IF NOT EXIST %UPDATE_MARKER_FILE% EXIT 1

cd c:\OpeneUI

git pull

call npm install
call bower update

del %UPDATE_MARKER_FILE%
call gulp all-modules-install
gulp all-modules build

:ex
EXIT 0