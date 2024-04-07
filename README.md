# Cluster Install
This repo contains `.bat` scripts to automate silent installation of softwares and configurations on windows cluster.

## Functionalities
- `start_ssh.bat`: Install openssh server, enable pubkey auth and start sshd service.
- `reset_pwd.bat`: Reset password for current user. PROMPED INPUT
- `install_anaconda.bat`: Download latest anaconda installer and silently install it. Remove installer after installation.
- `install_pasco.bat`: Use a local installer(specific version) to silently install pasco.
- `cluster_install.py`: Run on a machine to execute the scripts on others through ssh. 

## TODO
- Fully automated password reset by piping
- Check anaconda installation path
- Install python environment after anaconda installation
- Pasco install through internet
- Pasco license key