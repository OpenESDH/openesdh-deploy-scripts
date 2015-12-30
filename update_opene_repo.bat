@ECHO OFF

SET UPDATE_REPO_ZIP=C:\opene_updates\opene_repo\update_repo.zip

IF NOT EXIST %UPDATE_REPO_ZIP% EXIT 1

set ALF_HOME=c:\Alfresco\
set CATALINA_HOME=c:\Alfresco\tomcat

taskkill /F /FI "SERVICES eq alfrescoTomcat"

:install

SET unzip_folder=C:\Temp

Call :UnZipFile "%unzip_folder%\" "%UPDATE_REPO_ZIP%"

Call :PrepareAlfrescoWar

Call :InstallAmps
rem Call :InstallAmp annotations.amp
rem Call :InstallAmp webscripts.amp
rem Call :InstallAmp annotations-runtime.amp
rem Call :InstallAmp openesdh-repo.amp
rem Call :InstallAmp simple-case-repo.amp
rem Call :InstallAmp staff-repo.amp
rem Call :InstallAmp aoi-repo.amp
rem Call :InstallAmp office-repo.amp

call :InstallAddo

call "%ALF_HOME%bin\clean_tomcat.bat"

net start "alfrescoTomcat"

del %UPDATE_REPO_ZIP%

goto ex

:PrepareAlfrescoWar

rmdir /S /Q "%CATALINA_HOME%\webapps\alfresco"
del %CATALINA_HOME%\webapps\alfresco.war
copy %CATALINA_HOME%\webapps\alfresco.war_bak %CATALINA_HOME%\webapps\alfresco.war

exit /b 0


rem :InstallAmp <amp_file>
rem "%JAVA_HOME%\bin\java" -jar "%ALF_HOME%bin\alfresco-mmt.jar" install "%unzip_folder%" "%CATALINA_HOME%\webapps\alfresco.war" -directory -nobackup -force

:InstallAmps
rem find "openesdh-repo*.amp" file and install it first
set REPO_AMP='';
FOR /F "delims=" %%A IN ('dir %unzip_folder%\openesdh-repo*.amp /S /b') DO (
  set REPO_AMP=%%A
)
"%JAVA_HOME%\bin\java" -jar "%ALF_HOME%bin\alfresco-mmt.jar" install "%REPO_AMP%" "%CATALINA_HOME%\webapps\alfresco.war" -nobackup -force
del %REPO_AMP%

rem install all other amps
"%JAVA_HOME%\bin\java" -jar "%ALF_HOME%bin\alfresco-mmt.jar" install "%unzip_folder%" "%CATALINA_HOME%\webapps\alfresco.war" -directory -nobackup -force


exit /b 0

:InstallAddo
rmdir /S /Q "%CATALINA_HOME%\webapps\addo_webapp"
del %CATALINA_HOME%\webapps\addo_webapp.war
move C:\opene_updates\opene_repo\addo_webapp.war %CATALINA_HOME%\webapps\addo_webapp.war
exit /b 0


:UnZipFile <ExtractTo> <newzipfile>
rmdir /S /Q "%unzip_folder%"
call "C:\Program Files\7-Zip\7z" e %UPDATE_REPO_ZIP% -o%unzip_folder% -y

exit /b 0

:ex
EXIT 0