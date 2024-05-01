@ECHO OFF
ECHO Pradeep Created this script

:BEGIN
CALL :Frequecy
CALL :Amplitude
CALL :TestRun

if errorlevel 1 (
    echo An error occurred or the file was not found.
) else (
    echo File copied successfully.
)
PAUSE

Exit /b


:Frequecy
ECHO Testing Frequency
Exit /b

:Amplitude
ECHO Testing Amplitude
Exit /b

:TestRun
ECHO Running Test
REM TestName=GlacierTest_TEDS.ste
SET TestifyLocation="C:\Program Files\Agilent\Testify 5\Testify.exe"
SET FinalTestPath="C:\Users\singh035\Glacier-Small\Test\Testify\Regression\Vector\Feature\Master\GlacierTest_TEDS.ste"
REM FinalTestPath=%TestSuitePath% %TestName%
SET Profiler="C:\Users\singh035\Glacier-Small\Test\Testify\Regression\Vector\Feature\Master\Testify_Profile_x64_Local.tsp"
REM SET Profiler="Testify_Profile_x64_Local"
SET TestNameToBeSaveOnServer = VsaRegressionTest
SET SqlServer=SEPWEB.srs.is.keysight.com
SET Database=WBU_Testify

ECHO.
ECHO Running Testify suite DingoFunctionalTests.
%TestifyLocation% %FinalTestPath% /p:%Profiler% /r /x
REM %TestifyLocation% %FinalTestPath% /p:%Profile% /sno:%TestNameToBeSaveOnServer% /r /x %DisableTests%


REM Testify.exe [suitefile] [/p:profile] [/r] [/x] [/q] [/d] [/disable:<LOW><,MEDIUM><,HIGH>
REM [suitefile] – Is the full path to a suite enclosed in double quotes.
REM /p:profile – Applies a profile to a suite.
REM /r – Run the specified suite once it opens.
REM /x – Exit Testify after the suite completes.
REM Exit code = 0 – Indicates that no errors or failures occurred
REM Exit code = 1 – Indicates that failures and no errors occurred
REM Exit code = 2 – Indicates that at least 1 error occurred
REM /q – Quiet mode. This is the same as /x except it only exits if all tests pass.
REM /d – Restores the default window sizes and columns widths on the main form.
REM /count:n – Set the suite run count to repeat the execute of the test list multiple times.
REM /f – Turn on faceless testing. GUI is not updated in this mode.
REM /disable – Disables tests in a suite of specific test priority. Multiple levels of importance can be used separated by commas. Levels of importance are LOW, MEDIUM, and HIGH. Skip nodes are not disabled.
REM testify z:\Suites\TestEverything.ste /p:LocalSettings /r /x
REM testify z:\Suites\TestEverything.ste /p:LocalSettings /r /x /disable:LOW,HIGH
REM testify.exe ..\..\TestSomething.ste /p:\\server\sharedprofiles\LocalSettings.tsp