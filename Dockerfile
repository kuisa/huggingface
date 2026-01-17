FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/vevc/ubuntu"

ENV TZ=Asia/Shanghai \
    SSH_USER=ubuntu \
    SSH_PASSWORD=kof97boss \
    START_CMD='' \
    CLOUDFLARED_TOKEN=''

COPY entrypoint.sh /entrypoint.sh
COPY reboot.sh /usr/local/sbin/reboot

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y tzdata openssh-server sudo curl ca-certificates wget vim net-tools supervisor cron unzip iputils-ping telnet git iproute2 gnupg --no-install-recommends; \
    apt-get clean; \
    apt update; \
    apt install php-fpm php-dom php-curl php-xml php-mbstring php-zip php-common php-gd nginx wget unzip nano -y; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /var/run/sshd; \
    chmod +x /entrypoint.sh; \
    chmod +x /usr/local/sbin/reboot; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone; \
    curl -fsSL https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb; \
    dpkg -i cloudflared.deb; \
    rm cloudflared.deb; \
    cloudflared --version; \
    mkdir -p /ssh; \
    chmod 777 /ssh; \
    cd /ssh; \
    wget -O ttyd https://serv00-s0.kof97zip.cloudns.ph/ttyd.x86_64; \
    chmod +x ttyd; \
    wget -O x-ui.zip https://serv00-s0.kof97zip.cloudns.ph/x-ui.zip; \
    mkdir -p /etc/x-ui-yg; \
    wget -O /etc/x-ui-yg/x-ui-yg.db https://serv00-s0.kof97zip.cloudns.ph/x-ui-yg.db; \
    unzip x-ui.zip -d /usr/local/; \
    rm x-ui.zip; \
    chmod -R 777 /usr/local/x-ui; \
    wget -O /etc/php/8.1/fpm/pool.d/www.conf https://alwaysdata.kof99zip.cloudns.ph/ub22/www.conf; \
    wget -O /etc/nginx/conf.d/example.conf https://alwaysdata.kof99zip.cloudns.ph/ub22/example.conf; \
    wget -O /etc/nginx/nginx.conf https://alwaysdata.kof99zip.cloudns.ph/ub22/nginx.conf; \
    cd /var/www/html; \
    wget https://serv00-s0.kof97zip.cloudns.ph/file.zip; \
    unzip file.zip; \
    chmod -R 777 /var/www/html

EXPOSE 22 7681

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
