#!/usr/bin/env Rscript

# Проверка наличия пакета
if (!requireNamespace("dplyr", quietly = TRUE)) {
  stop("Пакет 'dplyr' не установлен.")
}

library(dplyr)

# Пути согласно требованиям задания
input_metadata <- "input/sample_metadata.csv"
input_ms       <- "input/mass_spec_results.csv"

# Проверка существования входных файлов
if (!file.exists(input_metadata)) stop("Файл не найден: ", input_metadata)
if (!file.exists(input_ms))       stop("Файл не найден: ", input_ms)

# Чтение данных
sample_metadata   <- read.csv(input_metadata, stringsAsFactors = FALSE)
mass_spec_results <- read.csv(input_ms,       stringsAsFactors = FALSE)

# Анти-левый джойн: метаданные без данных в масс-спектрометрии
anti_left <- anti_join(sample_metadata, mass_spec_results, by = "sample_id")

# Анти-правый джойн: данные масс-спектрометрии без метаданных
anti_right <- anti_join(mass_spec_results, sample_metadata, by = "sample_id")

# Анти-внешний джойн с пометкой источника
anti_outer <- bind_rows(
  anti_left  %>% mutate(источник = "sample_metadata"),
  anti_right %>% mutate(источник = "mass_spec_results")
)

# Создаём выходную директорию, если её нет
dir.create("output", showWarnings = FALSE)

# Сохраняем результаты в output/
write.csv(anti_left,  "output/anti_left.csv",  row.names = FALSE)
write.csv(anti_right, "output/anti_right.csv", row.names = FALSE)
write.csv(anti_outer, "output/anti_outer.csv", row.names = FALSE)

cat("Анти-джойны выполнены. Результаты сохранены в папку output/.\n")