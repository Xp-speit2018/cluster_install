@echo off
Setlocal EnableDelayedExpansion

:: Check and install OpenSSH Server if not installed
echo Checking for OpenSSH Server installation...
PowerShell -Command "& {if (-not(Get-WindowsCapability -Online | Where-Object { $_.Name -like 'OpenSSH.Server*' }).State -eq 'Installed') {Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0}}"

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

:: Restart SSHD service to apply changes
echo Restarting SSHD service...
net stop sshd
net start sshd

echo OpenSSH Server setup complete.
