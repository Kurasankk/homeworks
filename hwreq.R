## Задание 10

library(httr)
library(jsonlite)

# Список белков
proteins <- c('P01308', 'P62979', 'P61769', 'P04637', 'P10636',
              'P05067', 'P02768', 'P68871')

# Вектор для результатов
results <- numeric(length(proteins))
names(results) <- proteins

# Получаем данные для каждого белка
for (i in 1:length(proteins)) {
  acc <- proteins[i]
  cat("Обработка:", acc, "\n")
  
  # Формируем URL и параметры
  url <- "https://www.ebi.ac.uk/proteins/api/features"
  params <- list(accession = acc)
  
  # Отправляем GET-запрос
  response <- GET(url, query = params)
  
  # Проверяем успешность запроса
  if (response$status_code == 200) {
    # Парсим JSON-ответ
    data <- fromJSON(content(response, "text"))
    
    # Извлекаем длину последовательности
    if (nrow(data) > 0 && "sequence" %in% names(data)) {
      results[i] <- nchar(data$sequence[1])
      cat("Успешно:", acc, "-", results[i], "а.о.\n")
    } else {
      cat("Ошибка данных для", acc, "\n")
      results[i] <- NA
    }
  } else {
    cat("Ошибка запроса для", acc, "! Код:", response$status_code, "\n")
    results[i] <- NA
  }
  
  # Пауза между запросами
  Sys.sleep(0.3)
}

# Создаем data frame
df <- data.frame(
  protein = proteins,
  length = results
)

# Убираем NA
df <- df[!is.na(df$length), ]

# Выводим результаты
print(df)

# Строим столбчатую диаграмму
if (nrow(df) > 0) {
  barplot(df$length,
          names.arg = df$protein,
          main = "Длина белковых последовательностей",
          xlab = "Accession ID",
          ylab = "Длина (аминокислот)",
          col = "lightblue",
          las = 2)
} else {
  cat("Не удалось получить данные\n")
}

## Задание 13

# Минимальная версия для одного белка

accession <- "P04637"
fasta_content <- content(
  GET(paste0("https://www.ebi.ac.uk/proteins/api/proteins/", accession),
      add_headers(Accept = "text/x-fasta")),
  "text"
)
writeLines(fasta_content, "protein.fasta")
cat("Файл protein.fasta создан\n")
