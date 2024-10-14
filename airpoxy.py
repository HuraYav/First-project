import os

def create_proxy(count, username, password):
    # Установка необходимых пакетов
    os.system("apt-get update")
    os.system("apt-get -y install build-essential libwrap0-dev libpam0g-dev libkrb5-dev libsasl2-dev")
    os.system("wget --no-check-certificate https://ahmetshin.com/static/dante.tgz")
    os.system("tar -xvpzf dante.tgz")
    os.system("apt-get -y install libwrap0 libwrap0-dev")
    os.system("apt-get -y install gcc make")
    os.system("mkdir -p /home/dante")
    os.system("cd dante && ./configure --prefix=/home/dante && make && make install")

    # Создание базового конфигурационного файла Dante
    conf = """
logoutput: syslog /var/log/danted.log
external: ens3
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

    # Генерация конфигурации для заданного количества прокси
    with open("/home/dante/danted.conf", "w") as f:
        f.write(conf)
        for port in range(1080, 1080 + count):  # Порты от 1080 до (1080 + count)
            f.write(f"internal: ens3 port = {port}\n")

    # Создание пользователя с заданным логином и паролем
    os.system(f"useradd --shell /usr/sbin/nologin -m {username}")
    os.system(f'echo "{username}:{password}" | chpasswd')

    # Настройка фаервола
    os.system("apt-get -y install ufw")
    os.system("ufw allow ssh")
    os.system(f"ufw allow proto tcp from any to any port 1080:{1080 + count - 1}")
    os.system("ufw enable")

    # Запуск прокси
    os.system("/home/dante/sbin/sockd -f /home/dante/danted.conf -D")
    print("Прокси-серверы созданы и запущены!")

if __name__ == "__main__":
    count = int(input("Введите количество прокси для создания: "))
    username = input("Введите имя пользователя : ")
    password = input("Введите пароль : ")
    create_proxy(count, username, password)
