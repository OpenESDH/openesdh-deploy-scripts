@ECHO OFF
cd C:\opene_update_scripts
SET UPDATE_REPO_ZIP=C:\opene_updates\opene_repo\update_repo.zip

IF NOT EXIST %UPDATE_REPO_ZIP% EXIT 1

echo "%DATE% %TIME%" > last_job_log.txt

cmd /C update_opene_repo.bat >> last_job_log.txt 2>&1