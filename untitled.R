# Загрузка нужных библиотек
library(readxl)

# Пути к файлам внутри контейнера
input_file <- "/data/Пациенты.xlsx"
output_file <- "/data/анализ_гемоглобина.csv"

# Чтение данных
patients <- read_excel(input_file)

# Проверка типов
str(patients$Возраст)
str(patients$глюкоза)

# Преобразование категорий
patients$Пол <- factor(patients$Пол, levels = c("м", "ж"))
patients$возраст_группа_2 <- ifelse(patients$Возраст <= 60, "Молодые", "Старшие")

# Всего пациентов 27
patients[patients$Возраст > 75, ]

# Проверка лейкоцитов и глюкозы
head(patients$лейкоциты)
head(patients$глюкоза)
summary(patients$лейкоциты)
summary(patients$глюкоза)

# Средние значения по полу
print(aggregate(глюкоза ~ Пол, data = patients, FUN = mean))

# Средние по полу и возрастным группам
print(aggregate(лейкоциты ~ Пол + возраст_группа_2, data = patients, FUN = mean))

# Средние, СКО и n по полу
print(
  aggregate(глюкоза ~ Пол, data = patients,
            FUN = function(x) c(mean = mean(x), sd = sd(x), n = length(x)))
)

# Boxplot сохраняем в файл
png("/data/глюкоза_по_полу.png", width = 800, height = 600)
boxplot(глюкоза ~ Пол, data = patients,
        main = "Распределение уровня глюкозы по полу",
        xlab = "Пол", ylab = "Уровень глюкозы")
dev.off()

# === T-тест ===
patients_task <- patients
patients_task$`глюкоза`[c(3, 15, 45)] <- NA

t_test_result <- t.test(`лейкоциты` ~ Пол, data = patients_task)
print(t_test_result)
cat("p-value =", t_test_result$p.value, "\n")

# Работа с NA
sum(is.na(patients_task))
which(is.na(patients_task$глюкоза))

patients_no_na <- na.omit(patients_task)

glucose_median <- median(patients_task$глюкоза, na.rm = TRUE)
patients_task$глюкоза[is.na(patients_task$глюкоза)] <- glucose_median

aggregate(лейкоциты ~ Пол, data = patients_task, FUN = mean, na.rm = TRUE)
aggregate(лейкоциты ~ Пол, data = patients_no_na, FUN = mean)

# Финальный результат
final_result <- aggregate(гемоглобин ~ возраст_группа_2, data = patients_task,
                          FUN = function(x) c(среднее = mean(x), СКО = sd(x)))

final_result <- do.call(data.frame, final_result)
colnames(final_result) <- c("возраст_группа_2", "гемоглобин_среднее", "гемоглобин_СКО")

write.csv(final_result, output_file, row.names = FALSE)

cat("Результаты сохранены в:", output_file, "\n")
