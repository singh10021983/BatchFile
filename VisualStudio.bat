@ECHO OFF
ECHO Opening VisualStudio Test Solution and Building the Project
ECHO.

ECHO Open Visual Studio
REM START "Visual Studio 2022" "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe"
ECHO.

ECHO Open Visual Studio Project
REM START "Visual Studio" "C:\Pradeep\Spectrum Analyzer\Jenk_Jira_Git_Org\Jenkin\JenkinStudy\ArrayTestProject\ArrayTestProject.csproj"
ECHO.

ECHO Build the project
@echo off
set "MSBuildPath=C:\Program Files\Microsoft Visual Studio\2022\Professional\Msbuild\Current\Bin\MSBuild.exe"
set "ProjectFile=C:\Pradeep\Spectrum Analyzer\Jenk_Jira_Git_Org\Jenkin\JenkinStudy\ArrayTestProject\ArrayTestProject.csproj"
set "ExePath=C:\Pradeep\Spectrum Analyzer\Jenk_Jira_Git_Org\Jenkin\JenkinStudy\ArrayTestProject\bin\Release\ArrayTestProject.exe"

if exist "%MSBuildPath%" (
	REM Run Clean
    "%MSBuildPath%" "%ProjectFile%" /p:Configuration=Release /t:Clean 
	REM Run Build
	"%MSBuildPath%" "%ProjectFile%" /p:Configuration=Release
	REM Run Generated EXE file
	start "" "%ExePath%"
) else (
    echo MSBuild not found at "%MSBuildPath%"
)

PAUSE