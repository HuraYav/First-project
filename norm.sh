#!/bin/bash

# Файл, куда будет записываться конфигурация
CONFIG_FILE="/etc/3proxy.cfg"

# Удаляем старый файл конфигурации
rm -f $CONFIG_FILE

# Количество прокси
NUM_PROXIES=900

# Стартовый порт
START_PORT=30000

# Лог файл
echo "log /var/log/3proxy.log D" >> $CONFIG_FILE
echo 'logformat "L%d/%m/%Y %H:%M:%S %U %C %R %O %I %T %h %p %P"' >> $CONFIG_FILE

# Аутентификация по логину и паролю
echo "auth strong" >> $CONFIG_FILE

# Генерация прокси с уникальными логинами и паролями на разных портах
for ((i=0; i<$NUM_PROXIES; i++))
do
    PORT=$((START_PORT + i))
    LOGIN="24125"  # Логин для прокси
    PASSWORD="24125"  # Пароль для прокси

    # Добавляем логин и пароль для каждого порта
    echo "users $LOGIN:CL:$PASSWORD" >> $CONFIG_FILE
    echo "allow $LOGIN" >> $CONFIG_FILE
    echo "socks -p$PORT" >> $CONFIG_FILE

    # Выводим логин, пароль и порт на экран
    echo "Proxy $i: IP:PORT = <ваш_внешний_ip>:$PORT, Login = $LOGIN, Password = $PASSWORD"
done

echo "Конфигурация успешно создана в $CONFIG_FILE"
