#!/bin/bash

# Файл, куда будет записываться конфигурация
CONFIG_FILE="/etc/3proxy.cfg"

# Удаляем старый файл конфигурации
rm -f $CONFIG_FILE

# Количество прокси
NUM_PROXIES=900

# Стартовый порт
START_PORT=30000

# IP-адрес, который нужно использовать для прокси
PROXY_IP="104.238.61.158"

# Лог файл
echo "log /var/log/3proxy.log D" >> $CONFIG_FILE
echo 'logformat "L%d/%m/%Y %H:%M:%S %U %C %R %O %I %T %h %p %P"' >> $CONFIG_FILE

# Аутентификация по логину и паролю
echo "auth strong" >> $CONFIG_FILE

# Генерация прокси с уникальными логинами и паролями на разных портах
for ((i=0; i<$NUM_PROXIES; i++))
do
    PORT=$((START_PORT + i))
    LOGIN="user$i"  # Логин для прокси
    PASSWORD="pass$i"  # Пароль для прокси

    # Добавляем логин и пароль для каждого порта
    echo "users $LOGIN:CL:$PASSWORD" >> $CONFIG_FILE
    echo "allow $LOGIN" >> $CONFIG_FILE

    # Привязываем прокси к IP-адресу
    echo "socks -p$PORT -i$PROXY_IP -e$PROXY_IP" >> $CONFIG_FILE

    # Выводим логин, пароль и порт на экран
    echo "Proxy $i: IP:PORT = $PROXY_IP:$PORT, Login = $LOGIN, Password = $PASSWORD"
done

echo "Конфигурация успешно создана в $CONFIG_FILE"
