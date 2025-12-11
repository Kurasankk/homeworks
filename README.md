# Обработчик анти-джойнов в R 

Этот проект выполняет три типа анти-соединений (anti-joins) с помощью пакета `dplyr`:
- **Анти-левый**: строки из `sample_metadata`, отсутствующие в `mass_spec_results`
- **Анти-правый**: строки из `mass_spec_results`, отсутствующие в `sample_metadata`
- **Анти-внешний**: объединение обоих результатов с указанием источника каждой строки

Результаты сохраняются в виде CSV-файлов в папке `data/`.

## Входные данные

Поместите два CSV-файла в локальную папку `data/`:
- `data/sample_metadata.csv`
- `data/mass_spec_results.csv`

Оба файла **обязаны содержать колонку `sample_id`**.

## Сборка образа

```bash
docker build -t anti-join-processor .

## Запуск контейнера

```bash
docker run --rm \
  -v "$(pwd)/data:/app/data" \
  anti-join-processor