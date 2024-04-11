@REM RUN install_anaconda.bat
START /WAIT install_anaconda.bat

@REM RUN install_pasco.bat "licence_key"
START /WAIT install_pasco.bat %1
