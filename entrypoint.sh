#!/usr/bin/env sh

useradd -m -s /bin/bash $SSH_USER
echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
usermod -aG sudo $SSH_USER
echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/init-users
echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/my_sshd.conf

echo "Starting cloudflared with token"
nohup /usr/bin/cloudflared --no-autoupdate tunnel run --token $CLOUDFLARED_TOKEN > /dev/null 2>&1 &

echo "Starting ttyd"
nohup /ssh/ttyd -6 -p 7681 -c kof97zip:kof97boss -W bash 1>/dev/null 2>&1 &
nohup /usr/local/x-ui/x-ui > /dev/null 2>&1 &

if [ -n "$START_CMD" ]; then
    set -- $START_CMD
fi

exec "$@"
