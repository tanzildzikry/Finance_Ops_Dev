-- =========================================================
-- Phase 6 — Raw Source Load Validation
-- File: 01_database/validation/002_validate_raw_source_load.sql
-- Purpose:
--   Validate raw source load result after Phase 5
-- Expected:
--   raw.raw_bc_source = 8266 rows
--   raw.raw_pic_list  = 69 rows
-- =========================================================

\set ON_ERROR_STOP on

\echo 'START Phase 6 - Raw Source Load Validation'

\echo '1. Row count validation'

WITH row_count_validation AS (
    SELECT
        'raw.raw_bc_source' AS table_name,
        COUNT(*) AS actual_row_count,
        8266 AS expected_row_count,
        CASE
            WHEN COUNT(*) = 8266 THEN 'PASS'
            ELSE 'NEEDS REVISION'
        END AS validation_result
    FROM raw.raw_bc_source

    UNION ALL

    SELECT
        'raw.raw_pic_list' AS table_name,
        COUNT(*) AS actual_row_count,
        69 AS expected_row_count,
        CASE
            WHEN COUNT(*) = 69 THEN 'PASS'
            ELSE 'NEEDS REVISION'
        END AS validation_result
    FROM raw.raw_pic_list
)
SELECT
    table_name,
    actual_row_count,
    expected_row_count,
    validation_result
FROM row_count_validation
ORDER BY table_name;

\echo '2. Key integrity validation'

WITH key_validation AS (
    SELECT
        'raw.raw_bc_source.bc_number' AS control_name,
        COUNT(*) AS table_row_count,
        COUNT(*) FILTER (
            WHERE bc_number IS NULL
               OR btrim(bc_number) = ''
        ) AS null_or_blank_count,
        COUNT(*) - COUNT(DISTINCT NULLIF(btrim(bc_number), '')) AS duplicate_count
    FROM raw.raw_bc_source

    UNION ALL

    SELECT
        'raw.raw_pic_list.pic_code' AS control_name,
        COUNT(*) AS table_row_count,
        COUNT(*) FILTER (
            WHERE pic_code IS NULL
               OR btrim(pic_code) = ''
        ) AS null_or_blank_count,
        COUNT(*) - COUNT(DISTINCT NULLIF(btrim(pic_code), '')) AS duplicate_count
    FROM raw.raw_pic_list
)
SELECT
    control_name,
    table_row_count,
    null_or_blank_count,
    duplicate_count,
    CASE
        WHEN table_row_count = 0 THEN 'NEEDS REVISION'
        WHEN null_or_blank_count = 0 AND duplicate_count = 0 THEN 'PASS'
        WHEN null_or_blank_count = 0 AND duplicate_count > 0 THEN 'NEEDS REVIEW'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM key_validation
ORDER BY control_name;

\echo '3. Metadata validation'

SELECT
    source_file_name,
    COUNT(*) AS row_count,
    MIN(loaded_at) AS first_loaded_at,
    MAX(loaded_at) AS last_loaded_at
FROM raw.raw_bc_source
GROUP BY source_file_name

UNION ALL

SELECT
    source_file_name,
    COUNT(*) AS row_count,
    MIN(loaded_at) AS first_loaded_at,
    MAX(loaded_at) AS last_loaded_at
FROM raw.raw_pic_list
GROUP BY source_file_name
ORDER BY source_file_name;

\echo '4. Header / column count validation'

WITH column_count_validation AS (
    SELECT
        'raw.raw_bc_source' AS table_name,
        COUNT(*) AS actual_column_count,
        29 AS expected_column_count,
        CASE
            WHEN COUNT(*) = 29 THEN 'PASS'
            ELSE 'NEEDS REVIEW'
        END AS validation_result
    FROM information_schema.columns
    WHERE table_schema = 'raw'
      AND table_name = 'raw_bc_source'

    UNION ALL

    SELECT
        'raw.raw_pic_list' AS table_name,
        COUNT(*) AS actual_column_count,
        6 AS expected_column_count,
        CASE
            WHEN COUNT(*) = 6 THEN 'PASS'
            ELSE 'NEEDS REVIEW'
        END AS validation_result
    FROM information_schema.columns
    WHERE table_schema = 'raw'
      AND table_name = 'raw_pic_list'
)
SELECT
    table_name,
    actual_column_count,
    expected_column_count,
    validation_result
FROM column_count_validation
ORDER BY table_name;

\echo 'END Phase 6 - Raw Source Load Validation'