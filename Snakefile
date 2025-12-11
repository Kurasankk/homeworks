# Конфигурация путей
DATA_DIR = "input"
RESULT_DIR = "output"

# Прямые ссылки на данные (подставлены корректно, без лишних пробелов!)
MASS_SPEC_URL = "https://storage.yandexcloud.net/students-common/mass_spec_results.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJELqVUR2I4aFR9yju0lZmQ%2F20251129%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=20251129T075802Z&X-Amz-Expires=2592000&X-Amz-Signature=8696243c988ba07aaf3b8c3bbf6ef9eedaff7c5d6e4364aea6087493c19e3e39&X-Amz-SignedHeaders=host&response-content-disposition=attachment"

METADATA_URL = "https://storage.yandexcloud.net/students-common/sample_metadata.csv?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJELqVUR2I4aFR9yju0lZmQ%2F20251129%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=20251129T075822Z&X-Amz-Expires=2592000&X-Amz-Signature=10e1273d1fcbd5cba59ca00125eb26a4406c14a0ce39c97bcdd5a266493e8015&X-Amz-SignedHeaders=host&response-content-disposition=attachment"

# Путь к сохранённому Docker-образу (замените на свой!)
CONTAINER_IMAGE = "docker-archive:///home/polyakovaea/ms-antijoin-pipeline.tar"

# Целевые выходные файлы
rule all:
    input:
        f"{RESULT_DIR}/anti_left.csv",
        f"{RESULT_DIR}/anti_right.csv",
        f"{RESULT_DIR}/anti_outer.csv"

# Скачивание исходных данных
rule fetch_input_data:
    output:
        mass_spec = f"{DATA_DIR}/mass_spec_results.csv",
        metadata  = f"{DATA_DIR}/sample_metadata.csv"
    container:
        CONTAINER_IMAGE
    shell:
        """
        mkdir -p {DATA_DIR}
        curl -s -L "{MASS_SPEC_URL}" -o {output.mass_spec}
        curl -s -L "{METADATA_URL}" -o {output.metadata}
        echo "Данные успешно загружены в {DATA_DIR}/"
        """

# Выполнение анти-джойнов внутри контейнера
rule compute_antijoins:
    input:
        f"{DATA_DIR}/mass_spec_results.csv",
        f"{DATA_DIR}/sample_metadata.csv"
    output:
        f"{RESULT_DIR}/anti_left.csv",
        f"{RESULT_DIR}/anti_right.csv",
        f"{RESULT_DIR}/anti_outer.csv"
    container:
        CONTAINER_IMAGE
    shell:
        """
        mkdir -p {RESULT_DIR}
        Rscript /pipeline/join_data2.R
        """