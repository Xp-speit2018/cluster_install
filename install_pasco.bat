@echo off
REM Batch file for silent installation of PASCO_Capstone-2.6.0.10-x64.exe

REM Change directory to where the installer is located
@REM cd /D "C:\Users\Administrator\Desktop"

REM Execute the installer silently. Replace "/S" with the appropriate silent installation switch for your installer.
PASCO_Capstone-2.6.0.10-x64.exe /s /v"/qn LICENCEKEY=< My_Key > DISABLE_SOFTWARE_UPDATES=1"

REM Optional: Check if the installation was successful based on the error level (not all installers set this reliably)
if %ERRORLEVEL% NEQ 0 (
    echo Installation failed with error %ERRORLEVEL%.
) else (
    echo Installation completed successfully.
)

REM Pause the script to see the output when running manually (remove this line for fully unattended installation)
@REM pause
