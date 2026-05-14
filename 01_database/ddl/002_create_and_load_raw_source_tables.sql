\set ON_ERROR_STOP on

\echo 'START Phase 5 - Raw Layer Build controlled reload'

DROP TABLE IF EXISTS raw.raw_bc_source;
DROP TABLE IF EXISTS raw.raw_pic_list;

CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE raw.raw_pic_list (
    pic_full_name text,
    pic_code text,
    division_code text,
    pic_status text,
    source_file_name text DEFAULT 'masked_pic_list_sample.csv',
    loaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE raw.raw_bc_source (
    source_row_no text,
    event_name text,
    customer_name text,
    event_start_date text,
    event_end_date text,
    unbilled_aging_days text,
    event_status text,
    event_category text,
    pic_internal_code text,
    bc_number text,
    event_value_amount text,
    rab_budget_amount text,
    total_invoiced_amount text,
    umk_released_amount text,
    umk_issued_amount text,
    recording_period_date text,
    billing_remarks text,
    document_status_or_missing_notes text,
    ar_deadline_or_merge_invoice_notes text,
    pic_user_contact text,
    po_status_or_po_number text,
    umk_status text,
    billing_status text,
    invoice_number text,
    latest_invoice_date text,
    closing_duration_days text,
    handling_fee text,
    source_file_name text DEFAULT 'masked_bc_source_sample.csv',
    loaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

\echo 'Raw tables recreated.'

\echo 'Loading PIC CSV...'
\copy raw.raw_pic_list (pic_full_name, pic_code, division_code, pic_status) FROM 'D:/Tanzil/AR COLLECTION/_DASHBOARD POWER BI/Bahan SQL + PBI/finance_ops_dev/Repo Finance_Ops_Dev/03_sample_data_masked/masked_pic_list_sample.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8', QUOTE '"');

\echo 'Loading BC CSV...'
\copy raw.raw_bc_source (source_row_no, event_name, customer_name, event_start_date, event_end_date, unbilled_aging_days, event_status, event_category, pic_internal_code, bc_number, event_value_amount, rab_budget_amount, total_invoiced_amount, umk_released_amount, umk_issued_amount, recording_period_date, billing_remarks, document_status_or_missing_notes, ar_deadline_or_merge_invoice_notes, pic_user_contact, po_status_or_po_number, umk_status, billing_status, invoice_number, latest_invoice_date, closing_duration_days, handling_fee) FROM 'D:/Tanzil/AR COLLECTION/_DASHBOARD POWER BI/Bahan SQL + PBI/finance_ops_dev/Repo Finance_Ops_Dev/03_sample_data_masked/masked_bc_source_sample.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8', QUOTE '"');

\echo 'Running row count validation...'

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

\echo 'Running key integrity validation...'

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

\echo 'Running metadata validation...'

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

\echo 'END Phase 5 - Raw Layer Build controlled reload'