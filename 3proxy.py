import os
import random
import string

def generate_credentials():
    """Генерирует уникальный логин и пароль"""
    username = ''.join(random.choices(string.ascii_letters + string.digits, k=6))
    password = ''.join(random.choices(string.ascii_letters + string.digits, k=6))
    return username, password

def main():
    ip_address = "104.238.61.72"
    port_range = range(30000, 32000)  # 2000 портов
    
    # Генерация логина и пароля
    username, password = generate_credentials()

    # Установка 3proxy
    os.system("apt-get update")
    os.system("apt-get -y install 3proxy")

    # Создание конфигурационного файла
    with open("/etc/3proxy/3proxy.cfg", "w") as f:
        f.write("# Конфигурация 3proxy\n")
        f.write("nserver 8.8.8.8\n")
        f.write("nserver 8.8.4.4\n\n")
        
        for port in port_range:
            f.write(f"proxy -p{port} -a -u {username} -p {password}\n")

    # Запуск 3proxy
    os.system("systemctl restart 3proxy")

    print("Прокси-сервера созданы и запущены.")
    for port in port_range:
        print(f"Прокси: {ip_address}:{port}, Логин: {username}, Пароль: {password}")

if __name__ == "__main__":
    main()
