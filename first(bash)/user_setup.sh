#!/bin/bash

LOGFILE="./script.log"
exec > >(tee -a "$LOGFILE") 2>&1

# Запрашиваем путь, если не передан флаг -d
while getopts "d:" opt; do
  case $opt in
    d) DIR_PATH="$OPTARG" ;;
    *) echo "Неверный параметр"; exit 1 ;;
  esac
done

if [ -z "$DIR_PATH" ]; then
  read -p "Введите путь до директории: " DIR_PATH
fi

# Создание группы dev
echo "[INFO] Создание группы dev..."
groupadd -f dev

# Получение всех не системных пользователей
echo "[INFO] Поиск не системных пользователей..."
USERS=$(awk -F: '$3>=1000 && $1!="nobody" {print $1}' /etc/passwd)

# Добавление пользователей в группу dev
for user in $USERS; do
  echo "[INFO] Добавление пользователя $user в группу dev"
  usermod -aG dev "$user"

  # Создание директории
  USER_DIR="${DIR_PATH}/${user}_workdir"
  echo "[INFO] Создание директории $USER_DIR"
  mkdir -p "$USER_DIR"
  chown "$user:$user" "$USER_DIR"
  chmod 660 "$USER_DIR"

  # Разрешение чтения для группы dev
  setfacl -m g:dev:r "$USER_DIR"
done

# Права на sudo без пароля
echo "[INFO] Настройка sudo без пароля для группы dev..."
echo "%dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev_group
chmod 440 /etc/sudoers.d/dev_group

echo "[INFO] Скрипт завершен"

