\set ON_ERROR_STOP on

\echo 'START Phase 8 - Clean Layer Validation'

-- =========================================================
-- 1. Raw vs Clean Row Count Validation
-- =========================================================

\echo '1. Raw vs Clean row count validation'

WITH row_count_validation AS (
    SELECT
        'BC raw vs clean' AS control_name,
        (SELECT COUNT(*) FROM raw.raw_bc_source) AS raw_row_count,
        (SELECT COUNT(*) FROM clean.clean_bc) AS clean_row_count,
        8266 AS expected_row_count

    UNION ALL

    SELECT
        'PIC raw vs clean' AS control_name,
        (SELECT COUNT(*) FROM raw.raw_pic_list) AS raw_row_count,
        (SELECT COUNT(*) FROM clean.clean_pic_list) AS clean_row_count,
        69 AS expected_row_count
)
SELECT
    control_name,
    raw_row_count,
    clean_row_count,
    expected_row_count,
    CASE
        WHEN raw_row_count = clean_row_count
         AND clean_row_count = expected_row_count
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM row_count_validation
ORDER BY control_name;

-- =========================================================
-- 2. Key Integrity Validation
-- =========================================================

\echo '2. Key integrity validation'

WITH key_validation AS (
    SELECT
        'clean.clean_bc.bc_number' AS control_name,
        COUNT(*) AS table_row_count,
        COUNT(*) FILTER (
            WHERE bc_number IS NULL
               OR btrim(bc_number) = ''
        ) AS null_or_blank_count,
        COUNT(*) - COUNT(DISTINCT NULLIF(btrim(bc_number), '')) AS duplicate_count
    FROM clean.clean_bc

    UNION ALL

    SELECT
        'clean.clean_pic_list.pic_code' AS control_name,
        COUNT(*) AS table_row_count,
        COUNT(*) FILTER (
            WHERE pic_code IS NULL
               OR btrim(pic_code) = ''
        ) AS null_or_blank_count,
        COUNT(*) - COUNT(DISTINCT NULLIF(btrim(pic_code), '')) AS duplicate_count
    FROM clean.clean_pic_list
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

-- =========================================================
-- 3. Date Parsing Validation
-- =========================================================

\echo '3. Date parsing validation'

WITH date_validation AS (
    SELECT
        'event_start_date' AS control_name,
        COUNT(*) FILTER (WHERE r.event_start_date IS NOT NULL AND btrim(r.event_start_date) <> '') AS raw_non_blank_count,
        COUNT(*) FILTER (WHERE r.event_start_date IS NOT NULL AND btrim(r.event_start_date) <> '' AND c.event_start_date IS NOT NULL) AS clean_parsed_count,
        COUNT(*) FILTER (WHERE r.event_start_date IS NOT NULL AND btrim(r.event_start_date) <> '' AND c.event_start_date IS NULL) AS parse_failed_count
    FROM raw.raw_bc_source r
    LEFT JOIN clean.clean_bc c
        ON NULLIF(btrim(r.bc_number), '') = c.bc_number

    UNION ALL

    SELECT
        'event_end_date' AS control_name,
        COUNT(*) FILTER (WHERE r.event_end_date IS NOT NULL AND btrim(r.event_end_date) <> '') AS raw_non_blank_count,
        COUNT(*) FILTER (WHERE r.event_end_date IS NOT NULL AND btrim(r.event_end_date) <> '' AND c.event_end_date IS NOT NULL) AS clean_parsed_count,
        COUNT(*) FILTER (WHERE r.event_end_date IS NOT NULL AND btrim(r.event_end_date) <> '' AND c.event_end_date IS NULL) AS parse_failed_count
    FROM raw.raw_bc_source r
    LEFT JOIN clean.clean_bc c
        ON NULLIF(btrim(r.bc_number), '') = c.bc_number

    UNION ALL

    SELECT
        'recording_period_date' AS control_name,
        COUNT(*) FILTER (WHERE r.recording_period_date IS NOT NULL AND btrim(r.recording_period_date) <> '') AS raw_non_blank_count,
        COUNT(*) FILTER (WHERE r.recording_period_date IS NOT NULL AND btrim(r.recording_period_date) <> '' AND c.recording_period_date IS NOT NULL) AS clean_parsed_count,
        COUNT(*) FILTER (WHERE r.recording_period_date IS NOT NULL AND btrim(r.recording_period_date) <> '' AND c.recording_period_date IS NULL) AS parse_failed_count
    FROM raw.raw_bc_source r
    LEFT JOIN clean.clean_bc c
        ON NULLIF(btrim(r.bc_number), '') = c.bc_number

    UNION ALL

    SELECT
        'latest_invoice_date' AS control_name,
        COUNT(*) FILTER (WHERE r.latest_invoice_date IS NOT NULL AND btrim(r.latest_invoice_date) <> '') AS raw_non_blank_count,
        COUNT(*) FILTER (WHERE r.latest_invoice_date IS NOT NULL AND btrim(r.latest_invoice_date) <> '' AND c.latest_invoice_date IS NOT NULL) AS clean_parsed_count,
        COUNT(*) FILTER (WHERE r.latest_invoice_date IS NOT NULL AND btrim(r.latest_invoice_date) <> '' AND c.latest_invoice_date IS NULL) AS parse_failed_count
    FROM raw.raw_bc_source r
    LEFT JOIN clean.clean_bc c
        ON NULLIF(btrim(r.bc_number), '') = c.bc_number
)
SELECT
    control_name,
    raw_non_blank_count,
    clean_parsed_count,
    parse_failed_count,
    CASE
        WHEN parse_failed_count = 0 THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM date_validation
ORDER BY control_name;

-- =========================================================
-- 4. Amount Negative Validation
-- =========================================================

\echo '4. Amount negative validation'

WITH amount_negative_validation AS (
    SELECT 'event_value_amount' AS control_name, COUNT(*) FILTER (WHERE event_value_amount < 0) AS negative_count FROM clean.clean_bc
    UNION ALL
    SELECT 'rab_budget_amount' AS control_name, COUNT(*) FILTER (WHERE rab_budget_amount < 0) AS negative_count FROM clean.clean_bc
    UNION ALL
    SELECT 'total_invoiced_amount' AS control_name, COUNT(*) FILTER (WHERE total_invoiced_amount < 0) AS negative_count FROM clean.clean_bc
    UNION ALL
    SELECT 'umk_released_amount' AS control_name, COUNT(*) FILTER (WHERE umk_released_amount < 0) AS negative_count FROM clean.clean_bc
    UNION ALL
    SELECT 'umk_issued_amount' AS control_name, COUNT(*) FILTER (WHERE umk_issued_amount < 0) AS negative_count FROM clean.clean_bc
    UNION ALL
    SELECT 'handling_fee' AS control_name, COUNT(*) FILTER (WHERE handling_fee < 0) AS negative_count FROM clean.clean_bc
)
SELECT
    control_name,
    negative_count,
    CASE
        WHEN negative_count = 0 THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result
FROM amount_negative_validation
ORDER BY control_name;

-- =========================================================
-- 5. UNCLASSIFIED PIC Validation
-- =========================================================

\echo '5. UNCLASSIFIED PIC validation'

SELECT
    'UNCLASSIFIED PIC count' AS control_name,
    COUNT(*) FILTER (WHERE pic_internal_code = 'UNCLASSIFIED') AS actual_unclassified_count,
    12 AS expected_unclassified_count,
    CASE
        WHEN COUNT(*) FILTER (WHERE pic_internal_code = 'UNCLASSIFIED') = 12 THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result
FROM clean.clean_bc;

-- =========================================================
-- 6. PIC Orphan Validation
-- UNCLASSIFIED is allowed as correction bucket.
-- =========================================================

\echo '6. PIC orphan validation'

SELECT
    'PIC orphan excluding UNCLASSIFIED' AS control_name,
    COUNT(*) AS orphan_pic_count,
    CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result
FROM clean.clean_bc bc
LEFT JOIN clean.clean_pic_list pic
    ON bc.pic_internal_code = pic.pic_code
WHERE bc.pic_internal_code IS NOT NULL
  AND bc.pic_internal_code <> 'UNCLASSIFIED'
  AND pic.pic_code IS NULL;

-- =========================================================
-- 7. Billing Status Validation
-- =========================================================

\echo '7. Billing status validation'

WITH unexpected AS (
    SELECT
        COUNT(*) AS unexpected_status_count
    FROM clean.clean_bc
    WHERE billing_status IS NULL
       OR billing_status NOT IN ('BILLED', 'UNBILL', 'REPORTED')
)
SELECT
    'billing_status_known_values' AS control_name,
    unexpected_status_count,
    CASE
        WHEN unexpected_status_count = 0 THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result
FROM unexpected;

\echo '7a. Billing status distribution'

SELECT
    billing_status,
    COUNT(*) AS row_count
FROM clean.clean_bc
GROUP BY billing_status
ORDER BY row_count DESC, billing_status;

-- =========================================================
-- 8. Event Status Validation
-- =========================================================

\echo '8. Event status validation'

WITH unexpected AS (
    SELECT
        COUNT(*) AS unexpected_status_count
    FROM clean.clean_bc
    WHERE event_status IS NULL
       OR event_status NOT IN ('ENDED', 'ON GOING')
)
SELECT
    'event_status_known_values' AS control_name,
    unexpected_status_count,
    CASE
        WHEN unexpected_status_count = 0 THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result
FROM unexpected;

\echo '8a. Event status distribution'

SELECT
    event_status,
    COUNT(*) AS row_count
FROM clean.clean_bc
GROUP BY event_status
ORDER BY row_count DESC, event_status;

-- =========================================================
-- 9. Clean Metadata Validation
-- =========================================================

\echo '9. Clean metadata validation'

WITH metadata_validation AS (
    SELECT
        'clean.clean_bc' AS table_name,
        COUNT(*) AS table_row_count,
        COUNT(*) FILTER (WHERE source_file_name IS NULL OR btrim(source_file_name) = '') AS null_source_file_name_count,
        COUNT(*) FILTER (WHERE loaded_at IS NULL) AS null_loaded_at_count,
        COUNT(*) FILTER (WHERE cleaned_at IS NULL) AS null_cleaned_at_count
    FROM clean.clean_bc

    UNION ALL

    SELECT
        'clean.clean_pic_list' AS table_name,
        COUNT(*) AS table_row_count,
        COUNT(*) FILTER (WHERE source_file_name IS NULL OR btrim(source_file_name) = '') AS null_source_file_name_count,
        COUNT(*) FILTER (WHERE loaded_at IS NULL) AS null_loaded_at_count,
        COUNT(*) FILTER (WHERE cleaned_at IS NULL) AS null_cleaned_at_count
    FROM clean.clean_pic_list
)
SELECT
    table_name,
    table_row_count,
    null_source_file_name_count,
    null_loaded_at_count,
    null_cleaned_at_count,
    CASE
        WHEN table_row_count > 0
         AND null_source_file_name_count = 0
         AND null_loaded_at_count = 0
         AND null_cleaned_at_count = 0
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM metadata_validation
ORDER BY table_name;

-- =========================================================
-- 10. Clean Layer Final Summary
-- =========================================================

\echo '10. Clean layer final summary'

WITH checks AS (
    SELECT
        'row_count_bc' AS check_name,
        CASE WHEN (SELECT COUNT(*) FROM clean.clean_bc) = 8266 THEN 'PASS' ELSE 'NEEDS REVISION' END AS validation_result

    UNION ALL

    SELECT
        'row_count_pic' AS check_name,
        CASE WHEN (SELECT COUNT(*) FROM clean.clean_pic_list) = 69 THEN 'PASS' ELSE 'NEEDS REVISION' END AS validation_result

    UNION ALL

    SELECT
        'bc_key_integrity' AS check_name,
        CASE
            WHEN (
                SELECT COUNT(*)
                FROM clean.clean_bc
                WHERE bc_number IS NULL OR btrim(bc_number) = ''
            ) = 0
            AND (
                SELECT COUNT(*) - COUNT(DISTINCT NULLIF(btrim(bc_number), ''))
                FROM clean.clean_bc
            ) = 0
            THEN 'PASS'
            ELSE 'NEEDS REVISION'
        END AS validation_result

    UNION ALL

    SELECT
        'pic_key_integrity' AS check_name,
        CASE
            WHEN (
                SELECT COUNT(*)
                FROM clean.clean_pic_list
                WHERE pic_code IS NULL OR btrim(pic_code) = ''
            ) = 0
            AND (
                SELECT COUNT(*) - COUNT(DISTINCT NULLIF(btrim(pic_code), ''))
                FROM clean.clean_pic_list
            ) = 0
            THEN 'PASS'
            ELSE 'NEEDS REVISION'
        END AS validation_result

    UNION ALL

    SELECT
        'negative_amount_check' AS check_name,
        CASE
            WHEN (
                SELECT COUNT(*)
                FROM clean.clean_bc
                WHERE event_value_amount < 0
                   OR rab_budget_amount < 0
                   OR total_invoiced_amount < 0
                   OR umk_released_amount < 0
                   OR umk_issued_amount < 0
                   OR handling_fee < 0
            ) = 0
            THEN 'PASS'
            ELSE 'NEEDS REVIEW'
        END AS validation_result

    UNION ALL

    SELECT
        'pic_orphan_check' AS check_name,
        CASE
            WHEN (
                SELECT COUNT(*)
                FROM clean.clean_bc bc
                LEFT JOIN clean.clean_pic_list pic
                    ON bc.pic_internal_code = pic.pic_code
                WHERE bc.pic_internal_code IS NOT NULL
                  AND bc.pic_internal_code <> 'UNCLASSIFIED'
                  AND pic.pic_code IS NULL
            ) = 0
            THEN 'PASS'
            ELSE 'NEEDS REVIEW'
        END AS validation_result
)
SELECT
    check_name,
    validation_result
FROM checks
ORDER BY check_name;

\echo 'END Phase 8 - Clean Layer Validation'
