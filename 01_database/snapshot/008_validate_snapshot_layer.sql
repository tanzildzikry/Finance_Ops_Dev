\set ON_ERROR_STOP on

\echo 'START Phase 9.5 - Snapshot Layer Validation'

-- =========================================================
-- 1. Latest snapshot run log validation
-- =========================================================

\echo '1. Latest snapshot run log validation'

SELECT
    snapshot_run_id,
    snapshot_date,
    snapshot_cutoff_label,
    source_type,
    total_clean_bc_rows,
    total_snapshot_rows,
    total_issue_history_rows,
    snapshot_status,
    validation_result,
    risk_level,
    CASE
        WHEN snapshot_status = 'COMPLETED'
         AND validation_result = 'PASS'
         AND risk_level = 'LOW'
         AND total_clean_bc_rows = 8266
         AND total_snapshot_rows = 8266
         AND total_issue_history_rows = 8266
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS control_validation_result
FROM snapshot.snapshot_run_log
ORDER BY snapshot_run_id DESC
LIMIT 1;

-- =========================================================
-- 2. Latest snapshot view row count validation
-- =========================================================

\echo '2. Latest snapshot view row count validation'

SELECT
    'snapshot.vw_latest_bc_daily_status_snapshot' AS object_name,
    COUNT(*) AS actual_row_count,
    8266 AS expected_row_count,
    CASE WHEN COUNT(*) = 8266 THEN 'PASS' ELSE 'NEEDS REVISION' END AS validation_result
FROM snapshot.vw_latest_bc_daily_status_snapshot

UNION ALL

SELECT
    'snapshot.vw_latest_bc_daily_issue_history' AS object_name,
    COUNT(*) AS actual_row_count,
    8266 AS expected_row_count,
    CASE WHEN COUNT(*) = 8266 THEN 'PASS' ELSE 'NEEDS REVISION' END AS validation_result
FROM snapshot.vw_latest_bc_daily_issue_history
ORDER BY object_name;

-- =========================================================
-- 3. Snapshot key integrity validation
-- =========================================================

\echo '3. Snapshot key integrity validation'

SELECT
    'latest_snapshot_bc_number' AS control_name,
    COUNT(*) AS table_row_count,
    COUNT(*) FILTER (WHERE bc_number IS NULL OR btrim(bc_number) = '') AS null_or_blank_count,
    COUNT(*) - COUNT(DISTINCT NULLIF(btrim(bc_number), '')) AS duplicate_count,
    CASE
        WHEN COUNT(*) = 8266
         AND COUNT(*) FILTER (WHERE bc_number IS NULL OR btrim(bc_number) = '') = 0
         AND COUNT(*) - COUNT(DISTINCT NULLIF(btrim(bc_number), '')) = 0
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM snapshot.vw_latest_bc_daily_status_snapshot;

-- =========================================================
-- 4. Required snapshot control fields null validation
-- =========================================================

\echo '4. Required snapshot control fields null validation'

WITH control_nulls AS (
    SELECT
        COUNT(*) FILTER (WHERE is_open_unbilled IS NULL) AS null_is_open_unbilled,
        COUNT(*) FILTER (WHERE is_closed_fully_invoiced IS NULL) AS null_is_closed_fully_invoiced,
        COUNT(*) FILTER (WHERE is_reported_excluded IS NULL) AS null_is_reported_excluded,
        COUNT(*) FILTER (WHERE is_partial_invoice IS NULL) AS null_is_partial_invoice,
        COUNT(*) FILTER (WHERE is_over_invoiced_review IS NULL) AS null_is_over_invoiced_review,
        COUNT(*) FILTER (WHERE is_unclassified_pic IS NULL) AS null_is_unclassified_pic,
        COUNT(*) FILTER (WHERE high_risk_flag IS NULL) AS null_high_risk_flag,
        COUNT(*) FILTER (WHERE urgent_flag IS NULL) AS null_urgent_flag,
        COUNT(*) FILTER (WHERE needs_manual_review_flag IS NULL) AS null_needs_manual_review_flag,
        COUNT(*) FILTER (WHERE open_rab_exposure_amount IS NULL) AS null_open_rab_exposure_amount,
        COUNT(*) FILTER (WHERE invoice_gap_amount IS NULL) AS null_invoice_gap_amount,
        COUNT(*) FILTER (WHERE remaining_invoice_amount IS NULL) AS null_remaining_invoice_amount
    FROM snapshot.vw_latest_bc_daily_status_snapshot
)
SELECT
    *,
    CASE
        WHEN null_is_open_unbilled = 0
         AND null_is_closed_fully_invoiced = 0
         AND null_is_reported_excluded = 0
         AND null_is_partial_invoice = 0
         AND null_is_over_invoiced_review = 0
         AND null_is_unclassified_pic = 0
         AND null_high_risk_flag = 0
         AND null_urgent_flag = 0
         AND null_needs_manual_review_flag = 0
         AND null_open_rab_exposure_amount = 0
         AND null_invoice_gap_amount = 0
         AND null_remaining_invoice_amount = 0
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM control_nulls;

-- =========================================================
-- 5. REPORTED exclusion validation
-- Business rule:
--   REPORTED must not be active open backlog.
-- =========================================================

\echo '5. REPORTED exclusion validation'

SELECT
    'reported_excluded_logic' AS control_name,
    COUNT(*) FILTER (WHERE billing_status = 'REPORTED') AS reported_source_count,
    COUNT(*) FILTER (WHERE billing_status = 'REPORTED' AND is_reported_excluded = true) AS reported_excluded_count,
    COUNT(*) FILTER (WHERE billing_status = 'REPORTED' AND is_open_unbilled = true) AS reported_in_open_backlog_count,
    SUM(open_rab_exposure_amount) FILTER (WHERE billing_status = 'REPORTED') AS reported_open_rab_exposure_amount,
    CASE
        WHEN COUNT(*) FILTER (WHERE billing_status = 'REPORTED' AND is_open_unbilled = true) = 0
         AND COALESCE(SUM(open_rab_exposure_amount) FILTER (WHERE billing_status = 'REPORTED'), 0) = 0
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM snapshot.vw_latest_bc_daily_status_snapshot;

-- =========================================================
-- 6. Open exposure validation
-- Business rule:
--   open_rab_exposure_amount must be 0 for reported and closed fully invoiced.
-- =========================================================

\echo '6. Open exposure validation'

SELECT
    'open_exposure_closed_reported_zero' AS control_name,
    COUNT(*) FILTER (
        WHERE (is_reported_excluded = true OR is_closed_fully_invoiced = true)
          AND open_rab_exposure_amount <> 0
    ) AS invalid_closed_or_reported_open_exposure_count,
    COUNT(*) FILTER (
        WHERE is_open_unbilled = true
          AND is_reported_excluded = false
          AND is_closed_fully_invoiced = false
          AND open_rab_exposure_amount < 0
    ) AS negative_open_exposure_count,
    CASE
        WHEN COUNT(*) FILTER (
            WHERE (is_reported_excluded = true OR is_closed_fully_invoiced = true)
              AND open_rab_exposure_amount <> 0
        ) = 0
         AND COUNT(*) FILTER (
            WHERE is_open_unbilled = true
              AND is_reported_excluded = false
              AND is_closed_fully_invoiced = false
              AND open_rab_exposure_amount < 0
        ) = 0
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM snapshot.vw_latest_bc_daily_status_snapshot;

-- =========================================================
-- 7. High risk validation
-- Business rule:
--   High risk = aging > 60 and RAB >= 3,000,000,000 and not REPORTED.
-- =========================================================

\echo '7. High risk validation'

SELECT
    'high_risk_logic' AS control_name,
    COUNT(*) FILTER (WHERE high_risk_flag = true) AS high_risk_count,
    COUNT(*) FILTER (
        WHERE high_risk_flag = true
          AND NOT (
              unbilled_aging_days > 60
              AND COALESCE(rab_budget_amount, 0) >= 3000000000
              AND is_reported_excluded = false
          )
    ) AS invalid_high_risk_count,
    COUNT(*) FILTER (
        WHERE unbilled_aging_days > 60
          AND COALESCE(rab_budget_amount, 0) >= 3000000000
          AND is_reported_excluded = false
          AND high_risk_flag = false
    ) AS missed_high_risk_count,
    CASE
        WHEN COUNT(*) FILTER (
            WHERE high_risk_flag = true
              AND NOT (
                  unbilled_aging_days > 60
                  AND COALESCE(rab_budget_amount, 0) >= 3000000000
                  AND is_reported_excluded = false
              )
        ) = 0
         AND COUNT(*) FILTER (
            WHERE unbilled_aging_days > 60
              AND COALESCE(rab_budget_amount, 0) >= 3000000000
              AND is_reported_excluded = false
              AND high_risk_flag = false
        ) = 0
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM snapshot.vw_latest_bc_daily_status_snapshot;

-- =========================================================
-- 8. UNCLASSIFIED validation
-- Business rule:
--   UNCLASSIFIED is correction bucket, not PIC performance penalty.
-- =========================================================

\echo '8. UNCLASSIFIED PIC validation'

SELECT
    'unclassified_pic_count' AS control_name,
    COUNT(*) FILTER (WHERE is_unclassified_pic = true) AS actual_unclassified_count,
    12 AS expected_unclassified_count,
    COUNT(*) FILTER (WHERE is_unclassified_pic = true AND pic_internal_code <> 'UNCLASSIFIED') AS invalid_unclassified_flag_count,
    CASE
        WHEN COUNT(*) FILTER (WHERE is_unclassified_pic = true) = 12
         AND COUNT(*) FILTER (WHERE is_unclassified_pic = true AND pic_internal_code <> 'UNCLASSIFIED') = 0
        THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result
FROM snapshot.vw_latest_bc_daily_status_snapshot;

-- =========================================================
-- 9. Average aging logic validation
-- Business rule:
--   Average Aging Open BC must count only:
--   is_open_unbilled = true
--   event_status = 'ENDED'
--   unbilled_aging_days > 0
-- =========================================================

\echo '9. Average aging logic validation'

WITH manual_calc AS (
    SELECT
        AVG(unbilled_aging_days) FILTER (
            WHERE is_open_unbilled = true
              AND event_status = 'ENDED'
              AND unbilled_aging_days > 0
        ) AS manual_average_aging_open_bc,
        COUNT(*) FILTER (
            WHERE is_open_unbilled = true
              AND event_status = 'ENDED'
              AND unbilled_aging_days > 0
        ) AS included_row_count,
        COUNT(*) FILTER (
            WHERE is_open_unbilled = true
              AND (event_status <> 'ENDED' OR unbilled_aging_days <= 0 OR unbilled_aging_days IS NULL)
        ) AS excluded_open_row_count
    FROM snapshot.vw_latest_bc_daily_status_snapshot
),
view_calc AS (
    SELECT
        average_aging_open_bc
    FROM snapshot.vw_latest_snapshot_kpi_control
)
SELECT
    m.manual_average_aging_open_bc,
    v.average_aging_open_bc AS view_average_aging_open_bc,
    m.included_row_count,
    m.excluded_open_row_count,
    CASE
        WHEN ROUND(m.manual_average_aging_open_bc::numeric, 10) = ROUND(v.average_aging_open_bc::numeric, 10)
         AND v.average_aging_open_bc > 0
        THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM manual_calc m
CROSS JOIN view_calc v;

-- =========================================================
-- 10. KPI control view validation
-- =========================================================

\echo '10. KPI control view validation'

SELECT
    snapshot_run_id,
    snapshot_date,
    total_bc_count,
    open_bc_count,
    open_rab_exposure_amount,
    high_risk_bc_count,
    high_risk_rab_exposure_amount,
    reported_excluded_bc_count,
    unclassified_pic_count,
    manual_review_bc_count,
    average_aging_open_bc,
    CASE
        WHEN total_bc_count = 8266
         AND open_bc_count >= 0
         AND open_rab_exposure_amount >= 0
         AND high_risk_bc_count = 3
         AND reported_excluded_bc_count = 112
         AND unclassified_pic_count = 12
         AND manual_review_bc_count = 20
         AND average_aging_open_bc > 0
        THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result
FROM snapshot.vw_latest_snapshot_kpi_control;

-- =========================================================
-- 11. Snapshot issue history validation
-- =========================================================

\echo '11. Snapshot issue history validation'

SELECT
    'issue_history_latest_run' AS control_name,
    COUNT(*) AS issue_history_row_count,
    COUNT(*) FILTER (WHERE issue_source_text IS NULL OR btrim(issue_source_text) = '') AS blank_issue_source_text_count,
    COUNT(*) FILTER (WHERE detected_issue_category IS NULL) AS null_detected_issue_category_count,
    COUNT(*) FILTER (WHERE detected_blocker IS NULL) AS null_detected_blocker_count,
    CASE
        WHEN COUNT(*) = 8266
         AND COUNT(*) FILTER (WHERE detected_issue_category IS NULL) = 0
         AND COUNT(*) FILTER (WHERE detected_blocker IS NULL) = 0
        THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result
FROM snapshot.vw_latest_bc_daily_issue_history;

-- =========================================================
-- 12. Daily movement readiness validation
-- =========================================================

\echo '12. Daily movement readiness validation'

SELECT
    COUNT(DISTINCT snapshot_date) AS distinct_snapshot_dates,
    CASE
        WHEN COUNT(DISTINCT snapshot_date) >= 2 THEN 'PASS'
        ELSE 'NEEDS REVIEW'
    END AS validation_result,
    CASE
        WHEN COUNT(DISTINCT snapshot_date) >= 2 THEN 'Daily movement is meaningful.'
        ELSE 'Daily movement is not meaningful yet because fewer than 2 snapshot dates exist.'
    END AS control_note
FROM snapshot.bc_daily_status_snapshot;

-- =========================================================
-- 13. Final snapshot validation summary
-- =========================================================

\echo '13. Final snapshot validation summary'

WITH checks AS (
    SELECT 'latest_status_view_row_count' AS check_name,
           CASE WHEN (SELECT COUNT(*) FROM snapshot.vw_latest_bc_daily_status_snapshot) = 8266 THEN 'PASS' ELSE 'NEEDS REVISION' END AS validation_result

    UNION ALL

    SELECT 'latest_issue_view_row_count',
           CASE WHEN (SELECT COUNT(*) FROM snapshot.vw_latest_bc_daily_issue_history) = 8266 THEN 'PASS' ELSE 'NEEDS REVISION' END

    UNION ALL

    SELECT 'reported_excluded_not_open',
           CASE
               WHEN (
                   SELECT COUNT(*)
                   FROM snapshot.vw_latest_bc_daily_status_snapshot
                   WHERE billing_status = 'REPORTED'
                     AND is_open_unbilled = true
               ) = 0
               THEN 'PASS'
               ELSE 'NEEDS REVISION'
           END

    UNION ALL

    SELECT 'high_risk_logic',
           CASE
               WHEN (
                   SELECT COUNT(*)
                   FROM snapshot.vw_latest_bc_daily_status_snapshot
                   WHERE high_risk_flag = true
                     AND NOT (
                         unbilled_aging_days > 60
                         AND COALESCE(rab_budget_amount, 0) >= 3000000000
                         AND is_reported_excluded = false
                     )
               ) = 0
               THEN 'PASS'
               ELSE 'NEEDS REVISION'
           END

    UNION ALL

    SELECT 'average_aging_logic',
           CASE
               WHEN (
                   SELECT average_aging_open_bc
                   FROM snapshot.vw_latest_snapshot_kpi_control
                   LIMIT 1
               ) > 0
               THEN 'PASS'
               ELSE 'NEEDS REVISION'
           END
)
SELECT
    check_name,
    validation_result
FROM checks
ORDER BY check_name;

\echo 'END Phase 9.5 - Snapshot Layer Validation'
