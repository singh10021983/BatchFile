REM ========================================================================
REM Script will pull the latest for a given branch for both SA and SANightly repositories on the build machine
REM It is expected that SA and SANightly repositories are already cloned at C:\Git\Sep\
REM The branch to work with can be supplied as an argument to the script. If no argument is given , 
REM the script will assume the develop branch.
REM Example: batchfilename.bat bugfix/issue <-> will get latest from remote repositories for bugfix/issue branch
REM Example : batchfilename.bat <-> will get latest from remote develop branch
REM The script will also save a file with the SHA for the latest commit on the branch at C:\Temp\sa-repo-latestchangeset
REM This will be used in the publish scripts for SANightly to determine if the changeset has been published before.
REM ========================================================================
taskkill /F /IM Testify.exe /T
taskkill /F /IM TestifyX.exe /T
taskkill /F /IM devenv.exe /T


echo BuildLog > C:/Temp/sanightly-buildlog.txt

if "%~1"=="" (
	REM Set default branch if not argument
    set "branch=develop"
	
) else (
    set "branch=%~1"
)
echo Working with %branch% branch >> C:/Temp/sanightly-buildlog.txt



cd C:\Git\SEP\sa
echo Checking out %branch% on sa repo >> C:/Temp/sanightly-buildlog.txt
echo delete all local tracking branches which are no more on remote >> C:/Temp/sanightly-buildlog.txt 2>&1
git fetch --prune >> C:/Temp/sanightly-buildlog.txt 2>&1
git clean -xfd
git checkout %branch% >> C:/Temp/sanightly-buildlog.txt 2>&1
if %errorlevel% equ 0 (
	git reset --hard >> C:/Temp/sanightly-buildlog.txt 2>&1
	git pull >> C:/Temp/sanightly-buildlog.txt 2>&1
	REM create a dummy file indicating checkout has been successful, this will be used by the BuildTestAssemblies 
	REM test to control if sanightly is updated
	echo Checked out %branch% on sa repo >> C:/Temp/sanightly-buildlog.txt
) else (
	echo Sa checkout of branch %branch% failed >> C:/Temp/sanightly-buildlog.txt
	goto:eof
)


echo -------Done SA Repo. Starting SANightly repo----------------------------------- >> C:/Temp/sanightly-buildlog.txt 2>&1
