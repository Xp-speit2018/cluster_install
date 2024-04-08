@echo off
REM Check if a password argument was provided and use default if not
if "%~1"=="" (
    echo No new password provided. Using default password.
    set newPassword=123456
) else (
    set newPassword=%~1
)

REM Change the password
net user %username% %newPassword%
if %errorlevel% == 0 (
    echo Password changed successfully.
) else (
    echo Failed to change password.
)

@REM pause