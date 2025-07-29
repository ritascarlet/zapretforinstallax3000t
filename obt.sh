#!/bin/bash
# OfficialVPN Backup Tool v0.1.3 - Автоматическая установка
# Дата: 2025-07-28
# Новые возможности: Московское время + Авто-restart

set -e  # Выход при ошибке

echo "🚀 Установка OfficialVPN Backup Tool v0.1.3"
echo "============================================="
echo "🌍 Новое: Работа по московскому времени независимо от сервера"
echo "🔄 Новое: Автоматический restart после изменения времени"
echo ""

# Проверка прав root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Этот скрипт нужно запускать от root: sudo $0"
    exit 1
fi

# Проверка наличия systemd
if ! command -v systemctl >/dev/null 2>&1; then
    echo "❌ systemd не найден. Этот скрипт работает только с systemd."
    exit 1
fi



apt install wget git -y 
echo "✅ Проверки и обновления пройдены"

echo "Начинаю установку новой версии OBT"

cd

wget https://github.com/ritascarlet/zapretforinstallax3000t/raw/refs/heads/main/obt

# Функция установки
install_obt() {
    echo "📦 Установка исполняемого файла..."
    rm /usr/local/bin/obt

    # Проверяем наличие файла obt в текущей директории
    if [ -f "./obt" ]; then
        cp "./obt" /usr/local/bin/obt
        echo "✅ Скопирован ./obt в /usr/local/bin/obt"
    elif [ -f "./target/release/obt" ]; then
        cp "./target/release/obt" /usr/local/bin/obt
        echo "✅ Скопирован ./target/release/obt в /usr/local/bin/obt"
    else
        echo "❌ Файл obt не найден в текущей директории или target/release/"
        echo "   Поместите исполняемый файл obt в эту директорию и запустите скрипт снова"
        exit 1
    fi

    # Устанавливаем права и настройки
    chmod +x /usr/local/bin/obt
    chown root:root /usr/local/bin/obt
    (echo "4"; echo "1"; echo "00:00"; sleep 2; echo "6";) | sudo obt


    echo "✅ Права и настройки установлены"
}

# Функция проверки установки
check_installation() {
    echo "🔍 Проверка установки..."

    # Проверка файла
    if [ -f "/usr/local/bin/obt" ] && [ -x "/usr/local/bin/obt" ]; then
        echo "✅ Исполняемый файл установлен: /usr/local/bin/obt"
    else
        echo "❌ Проблема с исполняемым файлом"
        return 1
    fi

    # Проверка systemd
    if systemctl is-enabled obt.timer >/dev/null 2>&1; then
        echo "✅ systemd timer активен"
    else
        echo "❌ Проблема с systemd timer"
        return 1
    fi

    if systemctl is-active obt.service >/dev/null 2>&1; then
        echo "✅ systemd service запущен"
    else
        echo "⚠️  systemd service не активен (это нормально до первой настройки)"
    fi

    echo "✅ Установка завершена успешно!"
}

# Функция показа следующих шагов
show_next_steps() {
    echo ""
    echo "🎯 Следующие шаги:"
    echo "=================="
    echo ""
    echo "1. Запустите настройку:"
    echo "   sudo /usr/local/bin/obt"
    echo ""
    echo "2. В интерактивном меню настройте:"
    echo "   • URL репозитория Gitea"
    echo "   • Логин и пароль"
    echo "   • Имя бэкапа"
    echo "   • ⏰ Расписание (ПО МОСКОВСКОМУ ВРЕМЕНИ!)"
    echo "   • Пути для бэкапа"
    echo ""
    echo "3. Проверьте статус:"
    echo "   sudo systemctl status obt.service"
    echo "   sudo journalctl -u obt.service -f"
    echo ""
    echo "🌍 ВАЖНО: Время бэкапа теперь всегда по московскому времени"
    echo "🔄 ВАЖНО: Демон автоматически перезапускается при изменении времени"
    echo ""
    echo "📚 Полная документация: INSTALL.md"
}

# Основная логика
main() {
    echo "Начинаем установку..."
    echo ""

    install_obt
    check_installation
    show_next_steps

    echo ""
    echo "🎉 Установка OBT v0.1.3 завершена успешно!"
    echo "🌍 Поддержка московского времени активна"
    echo "🔄 Автоматический restart демона настроен"
}

# Запуск установки
main

echo ""
echo "🔧 Для управления сервисом используйте:"
echo "   sudo systemctl start|stop|restart obt.service"
echo "   sudo systemctl status obt.service"
echo "   sudo journalctl -u obt.service --since='1 hour ago'"
