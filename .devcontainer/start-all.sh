#!/usr/bin/env bash
set -e

# Start SSH server
mkdir -p /var/run/sshd
/usr/sbin/sshd || echo "sshd already running or failed"

# Start Horde LLM worker
cd /app
nohup ./horde-scribe-bridge.sh > /var/log/horde-scribe.log 2>&1 &

# Start JupyterLab on port 8888, no token
nohup jupyter lab --ip 0.0.0.0 --port 8888 --no-browser --NotebookApp.token='' \
  > /var/log/jupyter.log 2>&1 &

# Start simple FTP server on port 2121
nohup python3 -m pyftpdlib -p 2121 > /var/log/ftp.log 2>&1 &

# Keep container alive by tailing logs
touch /var/log/horde-scribe.log /var/log/jupyter.log /var/log/ftp.log
tail -F /var/log/horde-scribe.log /var/log/jupyter.log /var/log/ftp.log
