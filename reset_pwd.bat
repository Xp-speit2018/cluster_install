@echo off
REM Check if a password argument was provided
if "%~1"=="" (
    echo Usage: %0 newPassword
    exit /b 1
)

REM Set the new password from the first script argument
set newPassword=%~1

REM Change the password
net user %username% %newPassword%
if %errorlevel% == 0 (
    echo Password changed successfully.
) else (
    echo Failed to change password.
)

@REM pause

