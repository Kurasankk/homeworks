patients <- read_excel("~/hw1/Пациенты.xlsx")

# Оба стлобца числовые
str(patients$Возраст)
str(patients$глюкоза)

patients$Пол <- factor(patients$Пол, levels = c("м", "ж"))
levels(patients$Пол)

patients$возраст_группа_2 <- ifelse(patients$Возраст <= 60, "Молодые", "Старшие")

# всего пациентов 27
patients[patients$Возраст > 75, ]

# head(лейкоциты): 13.9 4.6 8.7 6.2 5.7 4.1
# summary(лейкоциты): Min = 3.000, 1st Q = 6.200, Median = 7.600, Mean = 8.069, 3rd Q  = 9.400, Max = 17.400.
# head(глюкоза): 25.1 5.4 4.8 5.5 5.5 16.7
# summary(глюкоза): Min = 4.200, 1st Q = 5.400, Median = 5.800, Mean = 6.539, 3rd Q = 6.700, Max = 26.700.

head(patients$лейкоциты)
head(patients$глюкоза)
summary(patients$лейкоциты)
summary(patients$глюкоза)

# Результат: мужчины — 6.404896, женщины — 6.841121.
aggregate(глюкоза ~ Пол, data = patients, FUN = mean)

# м, Молодые: 8.30447; ж, Молодые: 8.071429; м, Старшие: 8.133645; ж, Старшие: 7.532639
aggregate(лейкоциты ~ Пол + возраст_группа_2, data = patients, FUN = mean)

# Мужчины: mean = 6.404896, s = 2.160624, n = 241; Женщины: mean = 6.841121, s = 3.310702, n = 107
aggregate(глюкоза ~ Пол, data = patients, 
          FUN = function(x) c(mean = mean(x), sd = sd(x), n = length(x)))

# по средним из aggregate женщины имеют слегка большее среднее, но s у женщин больше — визуальный размах у женщин шире.
boxplot(глюкоза ~ Пол, data = patients,
        main = "Распределение уровня глюкозы по полу",
        xlab = "Пол", ylab = "Уровень глюкозы")

# T-тест: проверяем различается ли средний уровень лейкоцитов между мужчинами и женщинами
# Нулевая гипотеза H0: средние лейкоцитов равны у мужчин и женщин
# Альтернативная гипотеза H1: средние лейкоцитов различаются между мужчинами и женщинами
patients_task <- patients
patients_task$`глюкоза`[c(3,15,45)] <- NA

# Выполним t-тест по формуле "Лейкоциты ~ Пол"
t_test_result <- t.test(`лейкоциты` ~ Пол, data = patients_task)
t_test_result

print(t_test_result$p.value)

# результат: p = 0.09423532. При полученных значениях p > 0.05 → не отвергаем H0
# То есть недостаточно статистических доказательств, что средние лейкоцитов различаются между мужчинами и женщинами
# Также в тесте указаны средние: mean in group м = 8.228631, mean in group ж = 7.708879
# 95% CI для разности: -0.0898 … 1.1293.

sum(is.na(patients_task)) # вывод 3

which(is.na(patients_task$глюкоза)) # вывод 3, 15,45

patients_no_na <- na.omit(patients_task)
dim(patients_task)
dim(patients_no_na)

glucose_median <- median(patients_task$глюкоза, na.rm = TRUE)
patients_task$глюкоза[is.na(patients_task$глюкоза)] <- glucose_median

aggregate(лейкоциты ~ Пол, data = patients_task, FUN = mean, na.rm = TRUE)
aggregate(лейкоциты ~ Пол, data = patients_no_na, FUN = mean)

# Для patients_task: м = 8.228631, ж = 7.708879; Для patients_no_na: м = 8.228631, ж = 7.725481
# Отличие для женщин очень маленькое (7.708879 vs 7.725481) — т.е. практически не изменилось.

final_result <- aggregate(гемоглобин ~ возраст_группа_2, data = patients_task, 
                          FUN = function(x) c(среднее = mean(x), СКО = sd(x)))

final_result <- do.call(data.frame, final_result)

colnames(final_result) <- c("возраст_группа_2", "гемоглобин_среднее", "гемоглобин_СКО")

write.csv(final_result, "анализ_гемоглобина.csv", row.names = FALSE)

