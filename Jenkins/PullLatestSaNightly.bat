REM ========================================================================
REM This script can be used on Test PCs to get the latest test dlls on SANightly before running nightly test 
REM The script will pull the latest for SANIGHTLY repo cloned at C:\Git\Sep\sanightly.
REM If the repo is not cloned, this script will do nothing.
REM The script will take optional argument for the branch name. If no argument is given, 
REM then develop will be the default branch.
REM ========================================================================
taskkill /F /IM Testify.exe /T
taskkill /F /IM TestifyX.exe /T
taskkill /F /IM devenv.exe /T

setlocal EnableDelayedExpansion
REM Get current date and time in a format suitable for a file name
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
echo INFO: running Pull latest > C:/Temp/sanightly-log_%datetime%.txt
if "%~1"=="" (
	rem Set default branch if not argument
    set "branch=develop"
	echo INFO: Script run with no branch arguments. Checking out default branch !branch!>> C:/Temp/sanightly-log_%datetime%.txt
) else (
    set "branch=%~1"
	echo INFO: Script run with branch argument. Checking out custom branch !branch! >> C:/Temp/sanightly-log_%datetime%.txt	
)
cd C:\Git\SEP\sanightly

REM If the index lock file exist, clean the file and attempt to pull the latest
echo INFO: Checking if index.lock file exits >> C:/Temp/sanightly-log_%datetime%.txt
set "indexLockFilePath=C:\Git\SEP\sanightly\.git\index.lock" >> C:/Temp/sanightly-log_%datetime%.txt 2>&1
if exist %indexLockFilePath% (
	echo WARN: Found Index lock file at %indexLockFilePath%.  Will remove and attempt pull >> C:/Temp/sanightly-log_%datetime%.txt
	del "%indexLockFilePath%" >> C:/Temp/sanightly-log_%datetime%.txt 2>&1
) else (
	echo INFO: No index.lock file found >> C:/Temp/sanightly-log_%datetime%.txt
)

echo INFO: Fetching from remote >> C:/Temp/sanightly-log_%datetime%.txt
git fetch >> C:/Temp/sanightly-log_%datetime%.txt 2>&1
git branch >> C:/Temp/sanightly-log_%datetime%.txt 2>&1

echo INFO: Clean the repo >> C:/Temp/sanightly-log_%datetime%.txt
git clean -xfd

echo INFO: Checkout branch >> C:/Temp/sanightly-log_%datetime%.txt
git checkout %branch% >> C:/Temp/sanightly-log_%datetime%.txt 2>&1
git reset --hard origin/%branch% >> C:/Temp/sanightly-log_%datetime%.txt 2>&1
git pull >> C:/Temp/sanightly-log_%datetime%.txt 2>&1

echo INFO: Repo status post pulling latest code from remote
git status >> C:/Temp/sanightly-log_%datetime%.txt 2>&1

REM Confirm that index lock is not present. If it is, generate an ERROR to alert that 
REM repo may not be in a consistent/usable state
if exist "%indexLockFilePath%" (
	echo ERROR: Found Index lock file at %indexLockFilePath%.  Investigate repo status >> C:/Temp/sanightly-log_%datetime%.txt
)
echo end running Pull latest >> C:/Temp/sanightly-log_%datetime%.txt
endlocal