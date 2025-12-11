FROM python:3.11-slim

# Установка зависимостей
RUN pip install pandas

# Копируем скрипт
COPY join_data.py /app/join_data.py

# Делаем исполняемым
RUN chmod +x /app/join_data.py

# Рабочая директория
WORKDIR /app

# По умолчанию — запуск скрипта
CMD ["python", "join_data.py"]