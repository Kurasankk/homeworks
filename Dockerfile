FROM rocker/r-ver:4.4.0

# Устанавливаем dplyr и зависимости
RUN R -e "install.packages('dplyr', repos='https://cran.rstudio.com/')"

# Копируем R-скрипт в контейнер
COPY join.R /opt/join_data.R

# Делаем его исполняемым
RUN chmod +x /opt/join_data.R

# Запуск по умолчанию
CMD ["/opt/join_data.R"]