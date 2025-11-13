#!/usr/bin/env bash
set -e

# Start SSH server
mkdir -p /var/run/sshd
/usr/sbin/sshd || echo "sshd already running or failed"

# Start Horde LLM worker (micromamba env)
nohup /app/bin/micromamba run -r conda -n linux python /app/bridge_scribe.py \
  > /var/log/horde-scribe.log 2>&1 &

# Start simple FTP server on port 2121
nohup python3 -m pyftpdlib -p 2121 > /var/log/ftp.log 2>&1 &

# Make sure logs exist so tail doesn't fail
touch /var/log/horde-scribe.log /var/log/ftp.log

# Keep container alive
tail -F /var/log/horde-scribe.log /var/log/ftp.log
