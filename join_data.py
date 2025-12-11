#!/usr/bin/env python3

import pandas as pd
import os
import sys
import logging

# Настройка логирования
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger()

INPUT_DIR = "/input"
OUTPUT_DIR = "/output"

# Убедимся, что output существует и имеет права 777
os.makedirs(OUTPUT_DIR, exist_ok=True)
os.chmod(OUTPUT_DIR, 0o777)

# Пути к файлам
metadata_path = os.path.join(INPUT_DIR, "sample_metadata.csv")
ms_path = os.path.join(INPUT_DIR, "mass_spec_results.csv")

# Проверка наличия файлов
if not os.path.exists(metadata_path):
    logger.error(f"Input file not found: {metadata_path}")
    sys.exit(1)
if not os.path.exists(ms_path):
    logger.error(f"Input file not found: {ms_path}")
    sys.exit(1)

logger.info("Loading input data...")
metadata = pd.read_csv(metadata_path)
ms = pd.read_csv(ms_path)

logger.info(f"Loaded {len(metadata)} rows from sample_metadata")
logger.info(f"Loaded {len(ms)} rows from mass_spec_results")

# Inner join
logger.info("Performing inner join...")
inner = pd.merge(metadata, ms, on="sample_id", how="inner")
inner.to_csv(os.path.join(OUTPUT_DIR, "inner_join.csv"), index=False)
logger.info(f"Inner join completed: {len(inner)} rows saved.")

# Left join (metadata as left)
logger.info("Performing left join (sample_metadata left)...")
left = pd.merge(metadata, ms, on="sample_id", how="left")
left.to_csv(os.path.join(OUTPUT_DIR, "left_join.csv"), index=False)
logger.info(f"Left join completed: {len(left)} rows saved.")

# Right join
logger.info("Performing right join (mass_spec_results right)...")
right = pd.merge(metadata, ms, on="sample_id", how="right")
right.to_csv(os.path.join(OUTPUT_DIR, "right_join.csv"), index=False)
logger.info(f"Right join completed: {len(right)} rows saved.")

# Outer join
logger.info("Performing outer join...")
outer = pd.merge(metadata, ms, on="sample_id", how="outer")
outer.to_csv(os.path.join(OUTPUT_DIR, "outer_join.csv"), index=False)
logger.info(f"Outer join completed: {len(outer)} rows saved.")

logger.info("All joins completed successfully.")
