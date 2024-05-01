REM ================================= HERE IS THE LIST OF SUPPORTED MCS CONFIGURATIONS ================================
REM
REM 	F20Analog_NoJyn
REM 	F20Analog_WithJyn
REM 	F20VectorNB_NoJyn
REM 	F20VectorNB_WithJyn
REM 	F20VectorWB_NoJyn
REM 	F20VectorWB_WithJyn
REM 	F44Analog_NoJyn
REM 	F44Analog_NoJyn_WithAmp
REM 	F44Analog_WithJyn
REM 	F44Analog_WithJyn_WithAmp
REM 	F44VectorNB_NoJyn
REM 	F44VectorNB_NoJyn_WithAmp
REM 	F44VectorNB_WithJyn
REM 	F44VectorNB_WithJyn_WithAmp
REM 	F44VectorWB_NoJyn
REM 	F44VectorWB_NoJyn_WithAmp
REM 	F44VectorWB_WithJyn
REM 	F44VectorWB_WithJyn_WithAmp
REM
REM   Select one of the above configuraiton and replace in the variable "CONFIG" below for testing.
REM   DO NOT SIMPLY CHANGE CONFIG NAME
REM
REM ================================= HERE IS THE LIST OF SUPPORTED MCS CONFIGURATIONS ================================

REM Replace the config name here for use in test suite and testify profile
REM SET CONFIG=ReplaceThisWithConfigNameAbove
SET CONFIG=F20Analog_NoJyn


SET SUITEFILE_IVI_FUNCTEST="\\beryl.srs.is.keysight.com\testify\SEP\SignalSource\TestSuites\DingoFunctionalTests\DingoFunctionalTests.ste"
SET SUITEFILE_SCPI_FUNCTEST="\\beryl.srs.is.keysight.com\testify\SEP\SignalSource\TestSuites\DingoFunctionalTests\DingoScpiFunctionalTests.ste"
SET SUITEFILE_SCPI_UNITTEST="\\beryl.srs.is.keysight.com\testify\SEP\SignalSource\TestSuites\DingoFunctionalTests\DingoScpiUnitTests.ste"

"\\beryl.srs.is.keysight.com\Testify\SEP\SignalSource\TestSuites\DingoFunctionalTests\TestScript\msgbox.vbs" %Config% 

"C:\Program Files (x86)\Agilent\Testify 5\Testify.exe" %SUITEFILE_IVI_FUNCTEST% /p:MCSProfile_%CONFIG% /sno:DingoFunctionalTests_%CONFIG% /r /x /disable:LOW,MEDIUM

"C:\Program Files (x86)\Agilent\Testify 5\Testify.exe" %SUITEFILE_SCPI_FUNCTEST% /p:MCSProfile_%CONFIG% /sno:DingoScpiFunctionalTests_%CONFIG% /r /x /disable:LOW,MEDIUM

"C:\Program Files (x86)\Agilent\Testify 5\Testify.exe" %SUITEFILE_SCPI_UNITTEST% /p:MCSProfile_%CONFIG% /sno:DingoScpiUnitTests_%CONFIG% /r /x /disable:LOW,MEDIUM

pause
