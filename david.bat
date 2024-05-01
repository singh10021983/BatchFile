@ECHO OFF
SetLocal EnableDelayedExpansion
TITLE MCS 1.0 TEST SCRIPT

ECHO.
ECHO    Created by David Estes

:Begin
CALL :SelectFreq
CALL :SelectBand
CALL :SelectJyn
CALL :SelectAmp
CALL :SelectSuites
CALL :ConfirmSelection
IF ErrorLevel 2 (
	CALL :DiffConfigOrExit
	IF ErrorLevel 2 GOTO :EOF
	GOTO :Begin
)
CALL :RunTests
EndLocal
PAUSE
GOTO :EOF

:SelectFreq
ECHO.
CHOICE /C 24 /M "1) Chose frequency: 2=20Ghz, 4=44GHz "
IF ErrorLevel 2 (
	SET Freq=F44
) ELSE (
	SET Freq=F20
)
GOTO :EOF

:SelectBand
ECHO.
CHOICE /C ANW /M "2) Chose Band: A=Analog, N=Vector NB, W=Vector WB "
GOTO Band%ErrorLevel%
:Band1
	SET Band=Analog
	GOTO :EndBand
:Band2
	SET Band=VectorNB
	GOTO :EndBand
:Band3
	SET Band=VectorWB
	GOTO :EndBand
:EndBand
GOTO :EOF

:SelectJyn
ECHO.
CHOICE /M "3) Jyn "
IF ErrorLevel 2 (
	SET Jyn=_NoJyn
) ELSE (
	SET Jyn=_WithJyn
)
GOTO :EOF

:SelectAmp
IF %Freq% EQU F44 (
	ECHO.
	CHOICE /M "4) Amp "
	IF ErrorLevel 2 (
		SET Amp=
	) ELSE (
		SET Amp=_WithAmp
	)
) ELSE (
	SET Amp=
)
GOTO :EOF

:SelectSuites
ECHO.
CHOICE /C NW /M "5) Chose tests to run: N=Nightly, W=Weekend "
IF ErrorLevel 2 (
	SET DisableTests=
	SET TestsToRun=Weekend
) ELSE (
	SET DisableTests= /disable:LOW,MEDIUM
	SET TestsToRun=Nightly
)
GOTO :EOF

:ConfirmSelection
ECHO.
SET CONFIG=%Freq%%Band%%Jyn%%Amp%
ECHO    Configuration = %CONFIG%
ECHO    Tests To Run = %TestsToRun%
ECHO.
CHOICE /M "Is the above configuration correct "
GOTO :EOF

:DiffConfigOrExit
ECHO.
CHOICE /M "Do you want to (Y)test a different configuration or (N)exit "
GOTO :EOF

:RunTests
REM ECHO.
REM ECHO    Testing Configuration: %CONFIG%
REM ECHO    Running Tests: %TestsToRun%
REM ECHO.
TITLE %CONFIG%  ======  %TestsToRun%

REM File paths
SET SuiteLocation=\\beryl.srs.is.keysight.com\testify\SEP\SignalSource\TestSuites\DingoFunctionalTests\
SET TestifyLocation="C:\Program Files (x86)\Agilent\Testify 5\Testify.exe"
REM When debugging this batch file, comment the 2 lines above and uncomment the 2 lines below.
REM SET SuiteLocation={Testify Suite Folder Location Here}
REM SET TestifyLocation=ECHO {Testify.exe Location Here}

REM Alias M9383A-1 is needed by the SCPI tests.
ECHO.
CHOICE /M "Has the configuration to be tested been saved in SFP with connection name M9383A-1"
IF ErrorLevel 2 (
	ECHO.
	ECHO Please open the SFP and save the configuration with connection name M9383A-1.
	ECHO Press any key after exiting the SFP, or press CTRL-C to exit.
	PAUSE
)

REM Testify suite files
SET IviTest="%SuiteLocation%DingoFunctionalTests.ste"
SET ScpiFuncTest="%SuiteLocation%DingoScpiFunctionalTests.ste"
SET ScpiUnitTest="%SuiteLocation%DingoScpiUnitTests.ste"

REM Profile to use for all tests
SET Profile="MCSProfile_%CONFIG%"

REM Name to use for database results
SET IviDbName="DingoFunctionalTests_%CONFIG%"
SET ScpiFuncDbName="DingoScpiFunctionalTests_%CONFIG%"
SET ScpiUnitDbName="DingoScpiUnitTests_%CONFIG%"

REM Run tests
ECHO.
ECHO Running Testify suite DingoFunctionalTests.
%TestifyLocation% %IviTest% /p:%Profile% /sno:%IviDbName% /r /x%DisableTests%
ECHO.
ECHO Running Testify suite DingoScpiFunctionalTests.
%TestifyLocation% %ScpiFuncTest% /p:%Profile% /sno:%ScpiFuncDbName% /r /x%DisableTests%
ECHO.
ECHO Running Testify suite DingoScpiUnitTests.
%TestifyLocation% %ScpiUnitTest% /p:%Profile% /sno:%ScpiUnitDbName% /r /x%DisableTests%
ECHO.

GOTO :EOF
