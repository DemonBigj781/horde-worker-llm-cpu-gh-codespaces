#!/usr/bin/env bash
set -e

# Start SSH server
mkdir -p /var/run/sshd
/usr/sbin/sshd || echo "sshd already running or failed"

# Start Horde LLM worker
cd /app
nohup ./horde-scribe-bridge.sh > /var/log/horde-scribe.log 2>&1 &

# Start JupyterLab on port 8888, no token
# Use python3 -m jupyterlab so we don't care what the CLI binary is called
cd /workspaces || cd /app
nohup python3 -m jupyterlab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --ServerApp.token='' \
  --ServerApp.password='' \
  --ServerApp.allow_origin='*' \
  > /var/log/jupyter.log 2>&1 &

# Start simple FTP server on port 2121
nohup python3 -m pyftpdlib -p 2121 > /var/log/ftp.log 2>&1 &

# Make sure logs exist so tail doesn't crash
touch /var/log/horde-scribe.log /var/log/jupyter.log /var/log/ftp.log

# Keep container alive by tailing logs
tail -F /var/log/horde-scribe.log /var/log/jupyter.log /var/log/ftp.log
