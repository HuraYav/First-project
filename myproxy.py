import sys
import os

def main():
    username = "ad91234"
    try:
        password_proxy = raw_input("write your pass")
    except:
        password_proxy = input("write your pass")
    
    # Установка необходимых пакетов
    os.system("apt-get update")
    os.system("apt-get -y install build-essential libwrap0-dev libpam0g-dev libkrb5-dev libsasl2-dev")
    os.system("wget --no-check-certificate https://ahmetshin.com/static/dante.tgz")
    os.system("tar -xvpzf dante.tgz")
    os.system("apt-get -y install libwrap0 libwrap0-dev")
    os.system("apt-get -y install gcc make")
    os.system("mkdir /home/dante")
    os.system("cd dante && ./configure --prefix=/home/dante && make && make install")

    # Создание базового конфигурационного файла Dante
    conf = """
logoutput: syslog /var/log/danted.log
internal: eth0
external: eth0

socksmethod: username
user.privileged: root
user.unprivileged: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: error
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    command: connect
    log: error
    method: username
}
"""

    # Добавляем 1000 прокси с разными портами
    with open("/home/dante/danted.conf", "w") as f:
        f.write(conf)
        for port in range(1080, 2079):  # Порты от 1080 до 2079
            f.write(f"internal: eth0 port = {port}\n")
    
    # Создание пользователя
    os.system("useradd --shell /usr/sbin/nologin -m %s" % username)
    os.system('echo "%s:%s" | chpasswd' % (username, password_proxy))
    
    # Настройка фаервола
    os.system("apt-get -y install ufw")
    os.system("ufw status")
    os.system("ufw allow ssh")
    os.system("ufw allow proto tcp from any to any port 1080:2079")
    os.system("ufw status numbered")
    os.system("echo 'y' | ufw enable")

    # Добавление в автозапуск
    os.system("""
echo '#!/bin/sh -e
sleep 20
/home/dante/sbin/sockd -f /home/dante/danted.conf -D
exit 0
' > /etc/rc.local
""")
    os.system("chmod +x /etc/rc.local")
    os.system("chmod +x /home/dante/sbin/sockd")

    # Запуск прокси
    os.system("/home/dante/sbin/sockd -f /home/dante/danted.conf -D")
    os.system("echo 'proxy install success'")
    os.system("echo ' '")
    os.system("echo '________________________________'")
    os.system("echo ' '")
    os.system("echo \"YOUR IP ADDRESS: `hostname -I | awk '{print $1}'`\"")
    os.system("echo 'PORT RANGE: 1080-2079'")
    os.system("echo 'LOGIN: %s'" % username)
    os.system("echo 'PASSWORD: %s'" % password_proxy)

if __name__ == "__main__":
    main()
