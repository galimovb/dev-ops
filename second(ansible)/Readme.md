
# Ansible Homework — Настройка удалённого сервера с WSL Ubuntu


## 📂 Структура проекта

```bash
second/
├── inventory.ini      # Инвентарный файл Ansible
└── playbook.yml       # Основной Ansible Playbook
```

## 🧰 Используемые технологии

- WSL Ubuntu — локальная среда разработки
- Ansible — инструмент управления конфигурацией
- Timeweb VPS — целевой сервер Ubuntu
- SSH (key-based auth) — безопасное подключение к серверу

## 🔧 Что выполняет Playbook

Playbook `playbook.yml` делает следующее:

1. Создаёт нового пользователя `ansibleuser` на сервере
2. Добавляет его в группу `sudo`
3. Настраивает SSH-доступ по ключам для пользователя
4. Отключает вход по паролю в SSH
5. Создаёт директорию `/opt/ansibledir` с правами `0660`, принадлежащую `ansibleuser`

## 🚀 Как я это делал — Пошагово

### 1. Установка Ansible в WSL

```bash
sudo apt update
sudo apt install ansible -y
```

### 2. Генерация SSH-ключей

```bash
ssh-keygen -t rsa -b 4096 -C "ansible@37.252.21.198"
```

Ключи сохранились в:
- `~/.ssh/id_rsa` (приватный ключ)
- `~/.ssh/id_rsa.pub` (публичный ключ)

### 3. Добавление публичного ключа на сервер Timeweb

1. Скопировал содержимое `id_rsa.pub`
2. Вставил его в `/root/.ssh/authorized_keys` на сервере
3. Убедился, что права установлены правильно:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### 4. Проверка подключения

```bash
ssh root@<37.252.21.198 >
```

→ Успешный вход без пароля ✅


## ▶️ Запуск

Из папки проекта:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

## ✅ Проверка результатов
1. Подключение:

```bash
galim@Bu1a2:/mnt/c/Users/galim$ ssh ansibleuser@37.252.21.198

Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 5.15.0-134-generic x86_64)

```

2. Проверка sudo:

```bash
ansibleuser@4383207-mm23785:~$ sudo whoami
root
```

3. Проверка директории:

```bash
ansibleuser@4383207-mm23785:~$ ls -ld /opt/ansibledir
drw-rw---- 2 ansibleuser ansibleuser 4096 Jun 22 18:27 /opt/ansibledir
```

4. Проверка SSH-конфигурации:

```bash
ansibleuser@4383207-mm23785:~$ grep PasswordAuthentication /etc/ssh/sshd_config
PasswordAuthentication no
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication, then enable this but set PasswordAuthentication
```
5 Проверка директории:

```bash
ansibleuser@4383207-mm23785:~$ ls -ld /opt/ansibledir
drw-rw---- 2 ansibleuser ansibleuser 4096 Jun 22 18:27 /opt/ansibledir
```
