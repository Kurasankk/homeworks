# Джойны таблиц на Python (Inner, Left, Right, Outer)

Скрипт `join_data.py` внутри Docker-контейнера:

- проверяет наличие входных CSV-файлов;
- выполняет четыре типа SQL-подобных соединений по полю `sample_id`:
  - **inner** — только совпадающие строки из обеих таблиц;
  - **left** — все строки из `sample_metadata.csv`, даже без совпадений в `mass_spec_results.csv`;
  - **right** — все строки из `mass_spec_results.csv`, даже без совпадений в `sample_metadata.csv`;
  - **outer** — все строки из обеих таблиц (полное внешнее соединение);
- во время выполнения **логирует в консоль** каждый этап: загрузку данных, тип джойна, количество сохранённых строк;
- сохраняет результаты в смонтированную папку `/output` в виде:
  - `inner_join.csv`
  - `left_join.csv`
  - `right_join.csv`
  - `outer_join.csv`
- автоматически создаёт папку `output` с правами **777**, чтобы файлы были доступны вне контейнера.

## Входные данные

Входные файлы должны находиться в локальной папке `input/` и содержать колонку `sample_id`:

- `input/sample_metadata.csv`
- `input/mass_spec_results.csv`

(Файл `quality_data.csv` может присутствовать, но не используется)

## Сборка образа

```bash
docker build -t python-joins .

## Запуск образа

docker run --rm \
  -v "$(pwd)/input:/input" \
  -v "$(pwd)/output:/output" \
  python-joins
  
  После завершения работы контейнера результаты появятся в папке output/
```