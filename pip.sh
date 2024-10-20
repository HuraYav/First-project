#!/bin/bash

# Файл конфигурации
CONFIG_FILE="/etc/3proxy.cfg"

# Удаляем старый файл конфигурации
rm -f $CONFIG_FILE

# Количество прокси
NUM_PROXIES=1500

# Стартовый порт
START_PORT=30000

# Логин и пароль
PROXY_USER="pip2412"
PROXY_PASS="pip241"

# Лог файл
echo "log /var/log/3proxy.log D" >> $CONFIG_FILE
echo 'logformat "L%d/%m/%Y %H:%M:%S %U %C %R %O %I %T %h %p %P"' >> $CONFIG_FILE

# Аутентификация
echo "auth strong" >> $CONFIG_FILE
echo "users $PROXY_USER:CL:$PROXY_PASS" >> $CONFIG_FILE

# Разрешить всем с аутентификацией доступ
echo "allow $PROXY_USER" >> $CONFIG_FILE

# Генерация прокси на разных портах
for ((i=0; i<$NUM_PROXIES; i++))
do
    PORT=$((START_PORT + i))
    echo "socks -p$PORT -i104.238.61.158 -e104.238.61.158" >> $CONFIG_FILE
done

echo "Конфигурация успешно создана в $CONFIG_FILE"
