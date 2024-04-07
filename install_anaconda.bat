@echo off
@REM download and install Anaconda
set ANACONDA_LINK="https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Windows-x86_64.exe"

echo Downloading Anaconda Installer...
curl -L "%ANACONDA_LINK%" -o AnacondaInstaller.exe

echo Installing Anaconda...
start /wait "" AnacondaInstaller.exe /InstallationType=JustMe /AddToPath=1 /RegisterPython=1 /S /D=C:\Anaconda3

echo Anaconda Installation Complete!

@REM register path?
@REM setx PATH "%PATH%;C:\Anaconda3\Scripts;C:\Anaconda3\Library\bin;C:\Anaconda3"

@REM remove installer
del AnacondaInstaller.exe

@REM conda create some environment
@REM conda create -n myenv python=3.8
@REM conda activate myenv
@REM pip install -r requirements.txt