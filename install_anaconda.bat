@echo off
@REM download and install Anaconda if not already downloaded
set ANACONDA_LINK="https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Windows-x86_64.exe"
set INSTALLER=AnacondaInstaller.exe

if not exist "%INSTALLER%" (
    echo Downloading Anaconda Installer...
    curl -L %ANACONDA_LINK% -o %INSTALLER%
) else (
    echo Installer already exists, using existing file.
)

echo Installing Anaconda...
start /wait "" %INSTALLER% /InstallationType=JustMe /AddToPath=1 /RegisterPython=1 /S /D=C:\Anaconda3

echo Anaconda Installation Complete!

@REM Uncomment to register the Anaconda path after installation
setx PATH "%PATH%;C:\Anaconda3;C:\Anaconda3\Scripts;C:\Anaconda3\Library\bin"

@REM Remove installer if needed
@REM del %INSTALLER%

@REM Uncomment to create and prepare a conda environment
@REM conda create -n myenv python=3.8
@REM conda activate myenv
@REM pip install -r requirements.txt