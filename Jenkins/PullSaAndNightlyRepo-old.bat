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

REM delete a dummy file sanightlycheckoutsuccess.txt . This file indicates if sa nightly branch has been checked out successfully.
set "dummyFilePath=C:\Temp\sanightlycheckoutsuccess.txt"
if exist "%dummyFilePath%" (
	echo Deleting dummy file >> C:/Temp/sanightly-buildlog.txt
    del "%dummyFilePath%" >> C:/Temp/sanightly-buildlog.txt 2>&1
)

REM delete a dummy file sacheckoutsuccess.txt . This file indicates if sa branch has been checked out successfully.
set "dummyFilePath=C:\Temp\sacheckoutsuccess.txt"
if exist "%dummyFilePath%" (
	echo Deleting dummy file >> C:/Temp/sanightly-buildlog.txt
    del "%dummyFilePath%" >> C:/Temp/sanightly-buildlog.txt 2>&1
)

cd C:\Git\SEP\sa
echo Checking out %branch% on sa repo >> C:/Temp/sanightly-buildlog.txt
git fetch
echo delete all local tracking branches which are no more on remote >> C:/Temp/sanightly-buildlog.txt 2>&1
git remote prune origin >> C:/Temp/sanightly-buildlog.txt 2>&1
git clean -xfd
git checkout %branch% >> C:/Temp/sanightly-buildlog.txt 2>&1
if %errorlevel% equ 0 (
	git reset --hard >> C:/Temp/sanightly-buildlog.txt 2>&1
	git pull >> C:/Temp/sanightly-buildlog.txt 2>&1
	REM create a dummy file indicating checkout has been successful, this will be used by the BuildTestAssemblies 
	REM test to control if sanightly is updated
	echo Checked out %branch% on sa repo >> C:/Temp/sacheckoutsuccess.txt
	echo Checked out %branch% on sa repo >> C:/Temp/sanightly-buildlog.txt
) else (
	echo Sa checkout of branch %branch% failed >> C:/Temp/sanightly-buildlog.txt
	goto:eof
)


@echo off
setlocal
REM Use Git to get the changeset (commit hash) of the latest commit
for /f "delims=" %%i in ('git rev-parse HEAD') do set "changeset=%%i"

echo The changeset (commit hash) of the latest commit is: %changeset%
REM Define the file path where you want to save the changeset
set "outputFile=C:\Temp\sa-repo-latestchangeset.txt"

REM Save the changeset to the specified file
echo %changeset% > "%outputFile%"
echo The changeset (commit hash) of the latest commit has been saved to "%outputFile%". >> C:/Temp/sanightly-buildlog.txt
echo -------Done SA Repo. Starting SANightly repo----------------------------------- >> C:/Temp/sanightly-buildlog.txt 2>&1
endlocal

REM Check if SA Nightly folder is mapped 
@echo off
setlocal

REM Set the path of the folder you want to check
set "folderPath=C:\Git\Sep\sanightly"

REM Check if the folder exists
if exist "%folderPath%" (
    goto :GetLatestSaNightly
) else (
    echo The SA Nightly folder does not exist at %folderPath%. >> C:/Temp/sanightly-buildlog.txt
)

:GetLatestSaNightly
echo Getting the latest on SaNightly Repo >> C:/Temp/sanightly-buildlog.txt

cd %folderPath%
git clean -xfd
git fetch --prune
REM Check if the branch name exists in local sa nightly repo. 
goto :CheckoutLocalBranchIfExists
REM If branch exists, check out the branch
REM if the branch does not exist, check if the branch exists in remote
REM if the branch exists in remote, create a local tracking branch and checkout the branch
REM if the branch does not exist, nothing more to do. We cannot publish to a branch which does not exist 

goto:eof

:CheckoutLocalBranchIfExists
echo Checking if %branch% already exists in local sanightly repo >> C:/Temp/sanightly-buildlog.txt
git show-ref --verify --quiet refs/heads/%branch% > nul 2>&1

if %errorlevel% equ 0 (
    echo Branch exists in local repository. >> C:/Temp/sanightly-buildlog.txt
    goto :CheckoutLocalBranch
) else (
    echo Branch does not exist in local repository. >> C:/Temp/sanightly-buildlog.txt
    goto :CheckoutRemoteBranchIfExists
)
goto:eof

REM Check the remote branches . If the branch name is found, create a local branch tracking the remote 
REM and checkout 
:CheckoutRemoteBranchIfExists
echo Checking if %branch% exists in remote sanightly repo >> C:/Temp/sanightly-buildlog.txt
git ls-remote --exit-code --heads origin %branch% > nul 2>&1

if %errorlevel% equ 0 (
    echo Branch exists on remote repository. Creating local tracking branch>> C:/Temp/sanightly-buildlog.txt
    git branch --track %branch% origin/%branch%
    goto :CheckoutLocalBranch
) else (
    echo Branch does not exist on remote repository. Create new branch and push to remote  >> C:/Temp/sanightly-buildlog.txt
    git branch %branch%
    git push -u origin %branch%
    goto :CheckoutLocalBranch

)
goto:eof

REM Checkout a local branch and clean and merge
:CheckoutLocalBranch
echo Checking out %branch%  >> C:/Temp/sanightly-buildlog.txt
git checkout %branch% > nul 2>&1
if %errorlevel% equ 0 (
	git reset --hard origin/%branch%
	REM create a dummy file indicating checkout has been successful, this will be used by the BuildTestAssemblies 
	REM test to control if sanightly is updated
	echo Checked out %branch% on sanightly repo > C:/Temp/sanightlycheckoutsuccess.txt
	echo Checked out %branch% on sanightly repo >> C:/Temp/sanightly-buildlog.txt
) else (
	echo SaNightly checkout of branch %branch% failed >> C:/Temp/sanightly-buildlog.txt
)

goto:eof

endlocal