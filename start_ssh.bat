@echo off
Setlocal EnableDelayedExpansion

REM COPY ITEM
set "dir=%~dp0"
set "folder=OpenSSH-Win64"
xcopy "%dir%%folder%" "C:\%folder%" /E /I /Y

REM grant access of libcrypto.dll for all users
icacls C:\OpenSSH-Win64\libcrypto.dll /grant Everyone:RX

REM grant script execution access
PowerShell -Command "Set-ExecutionPolicy RemoteSigned"

REM run install script
PowerShell -ExecutionPolicy Bypass -File C:\OpenSSH-Win64\install-sshd.ps1

:: Automatically start the SSHD service on boot
echo Setting SSHD service to auto-start...
sc config sshd start= auto

:: Start the SSHD service
echo Starting SSHD service...
net start sshd

:: Enable public key authentication (updating the correct sshd_config location)
echo Enabling public key authentication...
PowerShell -Command "& {(Get-Content C:\ProgramData\ssh\sshd_config) -replace '#PubkeyAuthentication yes', 'PubkeyAuthentication yes' | Set-Content C:\ProgramData\ssh\sshd_config}"

:: Ensure the SSH server listens on port 22
PowerShell -Command "& {(Get-Content C:\ProgramData\ssh\sshd_config) -replace '#Port 22', 'Port 22' | Set-Content C:\ProgramData\ssh\sshd_config}"

:: Comment out AuthorizedKeysFile directive for the administrators group
echo Commenting out AuthorizedKeysFile directive for the administrators group...
PowerShell -Command "& {(Get-Content C:\ProgramData\ssh\sshd_config) -replace 'AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys', '#AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys' | Set-Content C:\ProgramData\ssh\sshd_config}"

:: Restart SSHD service to apply changes
echo Restarting SSHD service...
net stop sshd
net start sshd

echo OpenSSH Server setup complete.

REM genrate ssh key and copy pub
PowerShell -Command "(echo . echo . echo .) | ssh-keygen "
copy "%dir%pub_key" "%USERPROFILE%\.ssh\authorized_keys" /Y

pause