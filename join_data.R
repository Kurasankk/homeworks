#!/usr/bin/env Rscript

# Проверка
if (!requireNamespace("dplyr", quietly = TRUE)) {
  stop("Пакет 'dplyr' не установлен.")
}

# Загрузка библиотеки
library(dplyr)

# Пути к входным файлам
input_metadata <- "data/sample_metadata.csv"
input_ms       <- "data/mass_spec_results.csv"

# Проверка существования входных файлов
if (!file.exists(input_metadata)) stop("Файл не найден: ", input_metadata)
if (!file.exists(input_ms))       stop("Файл не найден: ", input_ms)

# Чтение данных (без преобразования строк в факторы)
sample_metadata   <- read.csv(input_metadata, stringsAsFactors = FALSE)
mass_spec_results <- read.csv(input_ms,       stringsAsFactors = FALSE)

# Анти-левый джойн: строки из метаданных, отсутствующие в результатах МС
anti_left <- anti_join(
  sample_metadata,
  mass_spec_results,
  by = "sample_id"
)

# Анти-правый джойн: строки из результатов МС, отсутствующие в метаданных
anti_right <- anti_join(
  mass_spec_results,
  sample_metadata,
  by = "sample_id"
)

# Анти-внешний джойн: объединение двух предыдущих результатов с пометкой источника
anti_outer <- bind_rows(
  anti_left  %>% mutate(источник = "sample_metadata"),
  anti_right %>% mutate(источник = "mass_spec_results")
)

# Сохранение результатов в CSV (без номеров строк)
write.csv(anti_left,  "data/anti_left.csv",  row.names = FALSE)
write.csv(anti_right, "data/anti_right.csv", row.names = FALSE)
write.csv(anti_outer, "data/anti_outer.csv", row.names = FALSE)

# Уведомление об успешном завершении
cat("Выполнены. Результаты сохранены в папку data/.\n")