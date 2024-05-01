REM ====================================================================================================
REM This script is used in Testify suite BuildTestAssemblies.ste to check if SANightly should be published.
REM The script will check if the latest changeset on SANightly is based off of the latest code on SA repo.
REM If the test dlls are based off of new code, this script will allow SaNighlty to be updated
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
exit 0
GOTO:eof

:DoNotUpdateNightlyRepo
echo The latest commit message in Nightly repo contains latest SA Repo changeset number: "!lineToSearchFor!" .SA Nightly repo will not be updated
exit 3
GOTO:eof
endlocal
