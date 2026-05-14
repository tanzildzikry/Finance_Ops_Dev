\set ON_ERROR_STOP on

\echo 'START Phase 7 - Raw to Clean Transform safe reload v3'

CREATE SCHEMA IF NOT EXISTS clean;

-- =========================================================
-- 1. Ensure clean.clean_pic_list exists and has required columns
-- =========================================================

CREATE TABLE IF NOT EXISTS clean.clean_pic_list (
    pic_full_name text
);

ALTER TABLE clean.clean_pic_list ADD COLUMN IF NOT EXISTS pic_code text;
ALTER TABLE clean.clean_pic_list ADD COLUMN IF NOT EXISTS division_code text;
ALTER TABLE clean.clean_pic_list ADD COLUMN IF NOT EXISTS pic_status text;
ALTER TABLE clean.clean_pic_list ADD COLUMN IF NOT EXISTS source_file_name text;
ALTER TABLE clean.clean_pic_list ADD COLUMN IF NOT EXISTS loaded_at timestamp without time zone;
ALTER TABLE clean.clean_pic_list ADD COLUMN IF NOT EXISTS cleaned_at timestamp without time zone;

-- =========================================================
-- 2. Ensure clean.clean_bc exists and has required columns
-- =========================================================

CREATE TABLE IF NOT EXISTS clean.clean_bc (
    source_row_no integer
);

ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS event_name text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS customer_name text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS event_start_date date;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS event_end_date date;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS unbilled_aging_days integer;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS event_status text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS event_category text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS pic_internal_code text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS bc_number text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS event_value_amount numeric;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS rab_budget_amount numeric;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS total_invoiced_amount numeric;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS umk_released_amount numeric;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS umk_issued_amount numeric;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS recording_period_date date;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS billing_remarks text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS document_status_or_missing_notes text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS ar_deadline_or_merge_invoice_notes text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS pic_user_contact text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS po_status_or_po_number text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS umk_status text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS billing_status text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS invoice_number text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS latest_invoice_date date;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS closing_duration_days integer;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS handling_fee numeric;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS source_file_name text;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS loaded_at timestamp without time zone;
ALTER TABLE clean.clean_bc ADD COLUMN IF NOT EXISTS cleaned_at timestamp without time zone;

-- =========================================================
-- 3. Controlled reload
-- =========================================================

TRUNCATE TABLE clean.clean_pic_list;
TRUNCATE TABLE clean.clean_bc;

INSERT INTO clean.clean_pic_list (
    pic_full_name,
    pic_code,
    division_code,
    pic_status,
    source_file_name,
    loaded_at,
    cleaned_at
)
SELECT
    NULLIF(btrim(pic_full_name), '') AS pic_full_name,
    UPPER(NULLIF(btrim(pic_code), '')) AS pic_code,
    UPPER(NULLIF(btrim(division_code), '')) AS division_code,
    UPPER(NULLIF(btrim(pic_status), '')) AS pic_status,
    source_file_name,
    loaded_at,
    CURRENT_TIMESTAMP AS cleaned_at
FROM raw.raw_pic_list;

INSERT INTO clean.clean_bc (
    source_row_no,
    event_name,
    customer_name,
    event_start_date,
    event_end_date,
    unbilled_aging_days,
    event_status,
    event_category,
    pic_internal_code,
    bc_number,
    event_value_amount,
    rab_budget_amount,
    total_invoiced_amount,
    umk_released_amount,
    umk_issued_amount,
    recording_period_date,
    billing_remarks,
    document_status_or_missing_notes,
    ar_deadline_or_merge_invoice_notes,
    pic_user_contact,
    po_status_or_po_number,
    umk_status,
    billing_status,
    invoice_number,
    latest_invoice_date,
    closing_duration_days,
    handling_fee,
    source_file_name,
    loaded_at,
    cleaned_at
)
SELECT
    NULLIF(btrim(source_row_no), '')::integer AS source_row_no,
    NULLIF(btrim(event_name), '') AS event_name,
    NULLIF(btrim(customer_name), '') AS customer_name,

    CASE
        WHEN NULLIF(btrim(event_start_date), '') IS NULL THEN NULL
        ELSE to_date(NULLIF(btrim(event_start_date), ''), 'MM/DD/YYYY')
    END AS event_start_date,

    CASE
        WHEN NULLIF(btrim(event_end_date), '') IS NULL THEN NULL
        ELSE to_date(NULLIF(btrim(event_end_date), ''), 'MM/DD/YYYY')
    END AS event_end_date,

    NULLIF(btrim(unbilled_aging_days), '')::integer AS unbilled_aging_days,
    UPPER(NULLIF(btrim(event_status), '')) AS event_status,
    UPPER(NULLIF(btrim(event_category), '')) AS event_category,

    CASE
        WHEN NULLIF(btrim(pic_internal_code), '') IS NULL
          OR UPPER(NULLIF(btrim(pic_internal_code), '')) IN ('#N/A', 'N/A', 'NA')
        THEN 'UNCLASSIFIED'
        ELSE UPPER(NULLIF(btrim(pic_internal_code), ''))
    END AS pic_internal_code,

    NULLIF(btrim(bc_number), '') AS bc_number,

    NULLIF(regexp_replace(btrim(event_value_amount), '[^0-9.-]', '', 'g'), '')::numeric AS event_value_amount,
    NULLIF(regexp_replace(btrim(rab_budget_amount), '[^0-9.-]', '', 'g'), '')::numeric AS rab_budget_amount,
    NULLIF(regexp_replace(btrim(total_invoiced_amount), '[^0-9.-]', '', 'g'), '')::numeric AS total_invoiced_amount,
    NULLIF(regexp_replace(btrim(umk_released_amount), '[^0-9.-]', '', 'g'), '')::numeric AS umk_released_amount,
    NULLIF(regexp_replace(btrim(umk_issued_amount), '[^0-9.-]', '', 'g'), '')::numeric AS umk_issued_amount,

    CASE
        WHEN NULLIF(btrim(recording_period_date), '') IS NULL THEN NULL
        ELSE to_date(NULLIF(btrim(recording_period_date), ''), 'MM/DD/YYYY')
    END AS recording_period_date,

    NULLIF(btrim(billing_remarks), '') AS billing_remarks,
    NULLIF(btrim(document_status_or_missing_notes), '') AS document_status_or_missing_notes,
    NULLIF(btrim(ar_deadline_or_merge_invoice_notes), '') AS ar_deadline_or_merge_invoice_notes,
    NULLIF(btrim(pic_user_contact), '') AS pic_user_contact,
    NULLIF(btrim(po_status_or_po_number), '') AS po_status_or_po_number,
    UPPER(NULLIF(btrim(umk_status), '')) AS umk_status,
    UPPER(NULLIF(btrim(billing_status), '')) AS billing_status,
    NULLIF(btrim(invoice_number), '') AS invoice_number,

    CASE
        WHEN NULLIF(btrim(latest_invoice_date), '') IS NULL THEN NULL
        ELSE to_date(NULLIF(btrim(latest_invoice_date), ''), 'MM/DD/YYYY')
    END AS latest_invoice_date,

    NULLIF(btrim(closing_duration_days), '')::integer AS closing_duration_days,
    NULLIF(regexp_replace(btrim(handling_fee), '[^0-9.-]', '', 'g'), '')::numeric AS handling_fee,

    source_file_name,
    loaded_at,
    CURRENT_TIMESTAMP AS cleaned_at
FROM raw.raw_bc_source;

-- =========================================================
-- 4. Validation
-- =========================================================

\echo 'Running clean row count validation...'

WITH validation AS (
    SELECT
        'clean.clean_bc' AS table_name,
        COUNT(*) AS actual_row_count,
        8266 AS expected_row_count,
        CASE WHEN COUNT(*) = 8266 THEN 'PASS' ELSE 'NEEDS REVISION' END AS validation_result
    FROM clean.clean_bc

    UNION ALL

    SELECT
        'clean.clean_pic_list' AS table_name,
        COUNT(*) AS actual_row_count,
        69 AS expected_row_count,
        CASE WHEN COUNT(*) = 69 THEN 'PASS' ELSE 'NEEDS REVISION' END AS validation_result
    FROM clean.clean_pic_list
)
SELECT *
FROM validation
ORDER BY table_name;

\echo 'END Phase 7 - Raw to Clean Transform safe reload v3'