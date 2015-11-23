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
"%JAVA_HOME%\bin\java" -jar "%ALF_HOME%bin\alfresco-mmt.jar" install "%unzip_folder%" "%CATALINA_HOME%\webapps\alfresco.war" -directory -nobackup -force

exit /b 0

:InstallAddo
rmdir /S /Q "%CATALINA_HOME%\webapps\addo_webapp"
del %CATALINA_HOME%\webapps\addo_webapp.war
move C:\opene_updates\opene_repo\addo_webapp.war %CATALINA_HOME%\webapps\addo_webapp.war
exit /b 0

:UnZipFile <ExtractTo> <newzipfile>
set vbs="%temp%\_.vbs"
if exist %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo If NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo End If
>>%vbs% echo Set objFSO = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo objFSO.DeleteFile(%1 + "*"), TRUE
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere FilesInZip, 256
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
>>%vbs% echo Set objFSO = Nothing
cscript //nologo %vbs%
if exist %vbs% del /f /q %vbs%

exit /b 0

:ex
EXIT 0