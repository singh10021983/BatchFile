REM ====================================================================================================
REM This script will use GitVersion tool which is configured in the repository 
REM The SemVer calculated by the GitVersion tool is saved to a temporary file in C:\Temp\sa-commit-version.txt
REM Other tests can use the file generated to appropriately tag the commit
REM ====================================================================================================

cd C:\Git\SEP\sa

dotnet dotnet-gitversion /showvariable FullSemVer > C:\Temp\sa-commit-version.txt

