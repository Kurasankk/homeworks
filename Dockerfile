FROM r-base:4.4.0

# Устанавливаем curl для скачивания данных (если нужно)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Устанавливаем необходимый R-пакет
RUN R -e "install.packages('dplyr', repos='https://cloud.r-project.org/')"

# Создаем рабочую директорию
WORKDIR /pipeline

# Копируем R-скрипт внутрь контейнера
COPY join_data2.R /pipeline/join_data2.R

# По умолчанию запускаем bash 
CMD ["/bin/bash"]