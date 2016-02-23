@ECHO OFF
cd C:\opene_update_scripts

SET UPDATE_MARKER_FILE=C:\opene_updates\opene_ui\update.txt

IF NOT EXIST %UPDATE_MARKER_FILE% EXIT 1

echo "%DATE% %TIME%" > last_job_ui_log.txt

cmd /C update_opene_ui.bat >> last_job_ui_log.txt 2>&1