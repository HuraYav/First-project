#!/bin/bash

# Файл, куда будет записываться конфигурация
CONFIG_FILE="/etc/3proxy.cfg"

# Удаляем старый файл конфигурации
rm -f $CONFIG_FILE

# Количество прокси
NUM_PROXIES=900

# Стартовый порт
START_PORT=30000

# IP-адреса для прокси
IP_ADDRESS="104.238.61.158"

# Логин и пароль для всех прокси
PROXY_LOGIN="2412"
PROXY_PASSWORD="2412"

# Лог файл
echo "log /var/log/3proxy.log D" >> $CONFIG_FILE
echo 'logformat "L%d/%m/%Y %H:%M:%S %U %C %R %O %I %T %h %p %P"' >> $CONFIG_FILE

# Аутентификация через логин и пароль
echo "auth strong" >> $CONFIG_FILE
echo "users $PROXY_LOGIN:CL:$PROXY_PASSWORD" >> $CONFIG_FILE

# Разрешить доступ только для авторизованных пользователей
echo "allow $PROXY_LOGIN" >> $CONFIG_FILE

# Генерация прокси SOCKS5 на разных портах
for ((i=0; i<$NUM_PROXIES; i++))
do
    PORT=$((START_PORT + i))
    echo "socks -p$PORT -i$IP_ADDRESS -e$IP_ADDRESS" >> $CONFIG_FILE
done

# Сообщение об успешной генерации
echo "Конфигурация успешно создана в $CONFIG_FILE"
