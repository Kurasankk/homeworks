---
editor_options: 
  markdown: 
    wrap: 72
---

# Snakemake Pipeline для анализа данных масс-спектрометрии

Этот проект реализует конвейер на основе **Snakemake** и **Docker**,
выполняющий анти-объединения (anti-joins) двух таблиц: -
`sample_metadata.csv` — метаданные образцов - `mass_spec_results.csv` —
результаты масс-спектрометрии

## Структура репозитория

-   `Snakefile` — определение pipeline
-   `Dockerfile` — сборка контейнера с R и dplyr
-   `join.R` — R-скрипт для обработки данных
-   `input/` — автоматически создаётся, содержит исходные CSV
-   `output/` — результаты анти-джойнов

## Инструкция по запуску

1.  **Соберите Docker-образ:** \`\`\`bash docker build -t
    ms-antijoin-pipeline .

2.  **Сохраните образ в архив:** \`\`\`bash docker save
    ms-antijoin-pipeline:latest -o \~/ms-antijoin-pipeline.tar

3.  **Запустите pipeline:** \`\`\`bash snakemake output/anti_outer.csv
    --cores 1 --use-singularity --printshellcmds

## Визуализации

Генерируются с помощью команд

\`\`\`bash snakemake --rulegraph \| dot -Tpng \> rulegraph.png snakemake
--filegraph \| dot -Tpng \> filegraph.png

<http://158.160.31.139:8787/files/rulegraph.png>

<http://158.160.31.139:8787/files/filegraph.png>
