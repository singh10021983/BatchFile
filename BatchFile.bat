cls
@echo off
echo "Hello Pradeep"
set variable=1
echo %variable%

set var=2

REM If Else condition
IF "%var%"==2 (
    ECHO Variable is 2
) ELSE (
    ECHO Variable is Not 2
)

REM For loop
FOR /L %%i in ( 1 2 3 ) DO (
    ECHO %%i
)

goto main

:function
echo Inside the function
exit /b

:main
echo Before the function
call :function
echo After the function
