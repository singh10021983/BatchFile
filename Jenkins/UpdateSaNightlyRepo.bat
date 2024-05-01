REM ====================================================================================================
REM This script is used by the Publish section of the Testify suite BuildTestAssemblies.ste .
REM The script will check if the latest changeset on SANightly is based off of the latest code on SA repo.
REM If the test dlls are based off of new code, this script will commit and push them to the remote SANightly repo
REM the commit message will contain the hostname of the build machine and the commit SHA of the SA repo based on which the dlls
REM have been created.
REM If the test dlls are not based on new code, this script will clean the SANightly repository.
REM ====================================================================================================

cd C:\Git\SEP\sanightly



@echo off
setlocal
setlocal EnableDelayedExpansion

rem Use Git to get the latest commit message
for /f "delims=" %%i in ('git log -1 --oneline') do set "latestCommitMessage=%%i"

rem Define the file path containing the string to search for
set "filePath=C:\Temp\sa-repo-latestchangeset.txt"

rem Read the line from the file
set "lineToSearchFor="
for /f "usebackq delims=" %%j in ("%filePath%") do (
    set "lineToSearchFor=%%j"
    goto :compareStrings
)

:compareStrings
rem Check if the latest commit message contains the line from the file
echo !latestCommitMessage! | findstr /C:"!lineToSearchFor!" >nul
if !errorlevel! equ 0 (
    goto :DoNotUpdateNightlyRepo    
) else (
    goto :UpdateNightlyRepo    
)

:UpdateNightlyRepo
echo The latest commit message in Nightly Repo does not contain latest SA Repo changeset number: "!lineToSearchFor!" .SA Nightly repo will be updated
git add .
git commit -a -m "Build on %COMPUTERNAME% - Dlls based on SA repo changeset !lineToSearchFor!"
git push
GOTO:eof

:DoNotUpdateNightlyRepo
echo The latest commit message in Nightly repo contains latest SA Repo changeset number: "!lineToSearchFor!" .SA Nightly repo will not be updated
git clean -xfd
git reset --hard origin/head
GOTO:eof
endlocal
