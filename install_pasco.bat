@echo off
REM Batch file for silent installation of PASCO_Capstone-2.6.0.10-x64.exe

REM Check for the presence of a command line argument (licence key)
IF "%~1"=="" (
    REM No licence key provided, proceed with installation without licence key
    ECHO Licence key not provided. Proceeding without it...
    PASCO_Capstone-2.6.0.10-x64.exe /s /v"/qn DISABLE_SOFTWARE_UPDATES=1"
) ELSE (
    REM Licence key provided, proceed with installation and include the licence key
    ECHO Licence key provided. Installing with key...
    PASCO_Capstone-2.6.0.10-x64.exe /s /v"/qn LICENCEKEY=%~1 DISABLE_SOFTWARE_UPDATES=1"
)

REM Optional: Check if the installation was successful based on the error level (not all installers set this reliably)
if %ERRORLEVEL% NEQ 0 (
    ECHO Installation failed with error %ERRORLEVEL%.
    EXIT /B %ERRORLEVEL%
) else (
    ECHO Installation completed successfully.
)

EXIT /B 0
