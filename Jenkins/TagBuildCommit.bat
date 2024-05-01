REM ====================================================================================================
REM This script will read the C:\Temp\sa-commit-version.txt file and use that value to create a 
REM tag for the SA Repo  
REM This batch file will get executed by the BuildTestAssemblies.ste suite file
REM ====================================================================================================

setlocal EnableDelayedExpansion
set "workingDir=%1"
cd %workingDir%
REM Read the tag name from the file
set "filePath=C:\Temp\sa-commit-version.txt"

set "TAG="
for /f "usebackq delims=" %%j in ("%filePath%") do (
    set "TAG=%%j"
)

REM Check if TAG variable is not empty
if not "!TAG!" == "" (
    REM Tag the latest commit
    git tag "!TAG!"
    git push origin "!TAG!"
    echo Tagged commit with tag: !TAG!
) else (
    echo Tag file %filePath% is empty or does not exist.
)

endlocal

