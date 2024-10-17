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

# Аутентификация (если нужна)
echo "auth none" >> $CONFIG_FILE

# Разрешить всем доступ
echo "allow *" >> $CONFIG_FILE

# Генерация прокси на разных портах
for ((i=0; i<$NUM_PROXIES; i++))
do
    PORT=$((START_PORT + i))
    echo "socks -p$PORT" >> $CONFIG_FILE
done

echo "Конфигурация успешно создана в $CONFIG_FILE"
