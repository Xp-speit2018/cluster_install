import os
import threading
from pathlib import Path

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
    
    cmd = f'ssh -p {port} {username}@{ip} ssh-keygen -t rsa && powershell "echo {pub_key} >> ~/.ssh/authorized_keys"'
    os.system(cmd)


def install_anaconda_windows(ip, username, port, dest):
    # run scp -P $PORT install_anaconda.bat $USERNAME@$HOST:$DEST and execute it
    os.system(f'scp -P {port} install_anaconda.bat {username}@{ip}:{dest}')
    os.system(f'ssh -p {port} {username}@{ip} "cd {dest} && install_anaconda.bat"')

if __name__ == "__main__":
    ips = [
        "43.163.203.200"
    ] # TODO: Add IP address
    username = 'Administrator' # TODO: Add username
    port = 22 # TODO: verify port

    # dest is path to desktop
    dest = f'C:\\Users\\{username}\\Desktop' # TODO: verify path
    
    # copy_pub sequentially
    for ip in ips:
        copy_pub(ip, username, port)

    # # use one thread for each IP, install_anaconda_windows
    # threads = []
    # for ip in ips:
    #     t = threading.Thread(target=install_anaconda_windows, args=(ip, username, port, dest))
    #     threads.append(t)
    #     t.start()
    
    # # wait for all threads to finish
    # for t in threads:
    #     t.join()
    


