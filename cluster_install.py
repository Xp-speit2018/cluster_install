import os
import threading
from pathlib import Path
import base64
from dotenv import load_dotenv

def copy_pub(ip, username, port, pub_key_path=Path.home() / '.ssh' / 'id_rsa.pub'):

    # load public key
    try:
        with open(pub_key_path, 'r') as f:
            pub_key = f.read().strip()
    except FileNotFoundError:
        # raise error
        raise FileNotFoundError(f'File {pub_key_path} not found')

    # if ~/.ssh/authorized_keys does not exist on remote, run ssh-keygen -t rsa
    # TODO: verify if ~/.ssh/authorized_keys exists on remote
    
    ps_command = f'''
    $sshDir = "$env:USERPROFILE\\.ssh"; 
    New-Item -ItemType Directory -Path $sshDir -Force -ErrorAction SilentlyContinue; 
    if (-Not (Test-Path "$sshDir\\id_rsa.pub")) {{ 
        ssh-keygen -t rsa -q -f "$sshDir\\id_rsa" -N '""'; 
    }} 
    Set-Content -Path "$sshDir\\authorized_keys" -Value "{pub_key}" -Force;
    '''

    # Encode the PowerShell command as base64
    ps_command_bytes = ps_command.encode('utf-16le') # PowerShell uses UTF-16LE encoding
    ps_command_b64 = base64.b64encode(ps_command_bytes).decode()


    cmd = f'ssh -p {port} {username}@{ip} powershell -EncodedCommand {ps_command_b64}'
    os.system(cmd)
    print(f'Public key copied to {ip}')

def copy_contents(ip, username, port, dest):
    # create a directory on remote
    os.system(f'ssh -p {port} {username}@{ip} mkdir {dest}')

    # copy all *.bat files to remote
    os.system(f'scp -P {port} *.bat {username}@{ip}:{dest}')

    # copy all *.exe files to remote
    os.system(f'scp -P {port} *.exe {username}@{ip}:{dest}')

def remote_install(ip, username, port, dest, pasco_key=None):
    # run install.bat on remote
    os.system(f'ssh -p {port} {username}@{ip} "cd {dest} && install_anaconda.bat && install_pasco.bat {pasco_key}"')

def _target(ip, username, port, dest, pasco_key=None):
    copy_pub(ip, username, port)
    copy_contents(ip, username, port, dest)
    remote_install(ip, username, port, dest, pasco_key)

if __name__ == "__main__":
    load_dotenv()
    pasco_key = os.getenv('PASCO_KEY')
    username = os.getenv('USERNAME')
    port = os.getenv('PORT')

    ips = [
        # "43.163.203.200",
        # "1.13.165.175",
        "146.56.226.108"
    ] # TODO: Add IP addresses

    # dest is path to store tmp scripts
    dest = f'scripts'
    
    # copy_pub sequentially
    for i, ip in enumerate(ips):
        print(f'Copying public key to {ip}, {i+1}/{len(ips)}')
        copy_pub(ip, username, port)

    # use one thread for each IP, _target
    threads = []
    for ip in ips:
        t = threading.Thread(target=_target, args=(ip, username, port, dest, pasco_key))
        threads.append(t)
        t.start()

    for t in threads:
        t.join()
    


