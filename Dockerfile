FROM rocker/r-base:latest

WORKDIR /app

RUN R -e "install.packages('readxl', repos='https://cloud.r-project.org/')"

COPY untitled.R script.R

CMD ["Rscript", "script.R"]
