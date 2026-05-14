\set ON_ERROR_STOP on

\echo 'START Phase 11.1 - Create Daily Latest Snapshot Views'

CREATE SCHEMA IF NOT EXISTS snapshot;

-- =========================================================
-- 1. Drop views in dependency-safe order
-- =========================================================

DROP VIEW IF EXISTS snapshot.vw_daily_kpi_control_latest_per_day;
DROP VIEW IF EXISTS snapshot.vw_daily_status_snapshot_latest_per_day;
DROP VIEW IF EXISTS snapshot.vw_daily_latest_snapshot_run;

-- =========================================================
-- 2. Latest completed PASS snapshot run per snapshot_date
-- Purpose:
--   Prevent double counting when multiple snapshot runs exist on the same date.
-- =========================================================

CREATE VIEW snapshot.vw_daily_latest_snapshot_run AS
WITH ranked_runs AS (
    SELECT
        r.snapshot_run_id,
        r.snapshot_date,
        r.snapshot_timestamp,
        r.snapshot_cutoff_label,
        r.source_type,
        r.source_file_name,
        r.total_clean_bc_rows,
        r.total_snapshot_rows,
        r.total_issue_history_rows,
        r.snapshot_status,
        r.validation_result,
        r.risk_level,
        r.notes,
        r.created_at,
        r.completed_at,
        ROW_NUMBER() OVER (
            PARTITION BY r.snapshot_date
            ORDER BY
                r.snapshot_run_id DESC
        ) AS daily_run_rank
    FROM snapshot.snapshot_run_log r
    WHERE r.snapshot_status = 'COMPLETED'
      AND r.validation_result = 'PASS'
)
SELECT
    snapshot_run_id,
    snapshot_date,
    snapshot_timestamp,
    snapshot_cutoff_label,
    source_type,
    source_file_name,
    total_clean_bc_rows,
    total_snapshot_rows,
    total_issue_history_rows,
    snapshot_status,
    validation_result,
    risk_level,
    notes,
    created_at,
    completed_at
FROM ranked_runs
WHERE daily_run_rank = 1;

-- =========================================================
-- 3. Daily latest status snapshot view
-- Purpose:
--   Power BI movement/trend fact source.
--   This view returns one latest valid run per snapshot_date.
-- =========================================================

CREATE VIEW snapshot.vw_daily_status_snapshot_latest_per_day AS
SELECT
    s.snapshot_run_id,
    s.snapshot_date,
    s.snapshot_timestamp,
    s.snapshot_cutoff_label,
    s.is_latest_snapshot_of_day,
    s.source_row_no,
    s.bc_number,
    s.event_name,
    s.customer_name,
    s.pic_internal_code,
    s.event_category,
    s.event_status,
    s.billing_status,
    s.invoice_number,
    s.event_start_date,
    s.event_end_date,
    s.recording_period_date,
    s.latest_invoice_date,
    s.snapshot_year_month,
    s.event_end_year_month,
    s.invoice_year_month,
    s.event_value_amount,
    s.rab_budget_amount,
    s.total_invoiced_amount,
    s.umk_released_amount,
    s.umk_issued_amount,
    s.handling_fee,
    s.invoice_completion_ratio,
    s.invoice_completion_bucket,
    s.bc_closing_status,
    s.unbilled_aging_days,
    s.aging_bucket,
    s.closing_duration_days,
    s.closing_duration_bucket,
    s.is_open_unbilled,
    s.is_closed_fully_invoiced,
    s.is_reported_excluded,
    s.is_partial_invoice,
    s.is_over_invoiced_review,
    s.is_unclassified_pic,
    s.open_rab_exposure_amount,
    s.invoice_gap_amount,
    s.remaining_invoice_amount,
    s.high_risk_flag,
    s.urgent_flag,
    s.risk_level,
    s.needs_manual_review_flag,
    s.data_quality_flag,
    s.data_quality_issue_count,
    s.billing_remarks,
    s.document_status_or_missing_notes,
    s.ar_deadline_or_merge_invoice_notes,
    s.pic_user_contact,
    s.po_status_or_po_number,
    s.umk_status,
    s.issue_source_text,
    s.detected_issue_category,
    s.detected_blocker,
    s.responsibility_type,
    s.issue_confidence_level,
    s.classification_method,
    s.source_file_name,
    s.source_row_hash,
    s.record_hash,
    s.loaded_at,
    s.cleaned_at,
    s.created_at
FROM snapshot.bc_daily_status_snapshot s
JOIN snapshot.vw_daily_latest_snapshot_run r
    ON s.snapshot_run_id = r.snapshot_run_id;

-- =========================================================
-- 4. Daily KPI control latest-per-day view
-- Purpose:
--   Reconciliation source for movement/trend KPI by snapshot_date.
-- =========================================================

CREATE VIEW snapshot.vw_daily_kpi_control_latest_per_day AS
SELECT
    snapshot_run_id,
    snapshot_date,
    COUNT(*) AS total_bc_count,
    COUNT(*) FILTER (WHERE is_open_unbilled = true) AS open_bc_count,
    SUM(open_rab_exposure_amount) AS open_rab_exposure_amount,
    COUNT(*) FILTER (WHERE high_risk_flag = true) AS high_risk_bc_count,
    SUM(CASE WHEN high_risk_flag = true THEN open_rab_exposure_amount ELSE 0 END) AS high_risk_rab_exposure_amount,
    COUNT(*) FILTER (WHERE is_reported_excluded = true) AS reported_excluded_bc_count,
    COUNT(*) FILTER (WHERE is_unclassified_pic = true) AS unclassified_pic_count,
    COUNT(*) FILTER (WHERE needs_manual_review_flag = true) AS manual_review_bc_count,
    AVG(unbilled_aging_days) FILTER (
        WHERE is_open_unbilled = true
          AND event_status = 'ENDED'
          AND unbilled_aging_days > 0
    ) AS average_aging_open_bc
FROM snapshot.vw_daily_status_snapshot_latest_per_day
GROUP BY
    snapshot_run_id,
    snapshot_date;

-- =========================================================
-- 5. View existence validation
-- =========================================================

\echo '1. View existence validation'

WITH required_views AS (
    SELECT 'snapshot.vw_daily_latest_snapshot_run' AS view_name
    UNION ALL
    SELECT 'snapshot.vw_daily_status_snapshot_latest_per_day'
    UNION ALL
    SELECT 'snapshot.vw_daily_kpi_control_latest_per_day'
),
view_validation AS (
    SELECT
        rv.view_name,
        CASE
            WHEN v.table_schema IS NOT NULL THEN 'PASS'
            ELSE 'NEEDS REVISION'
        END AS validation_result
    FROM required_views rv
    LEFT JOIN information_schema.views v
        ON split_part(rv.view_name, '.', 1) = v.table_schema
       AND split_part(rv.view_name, '.', 2) = v.table_name
)
SELECT
    view_name,
    validation_result
FROM view_validation
ORDER BY view_name;

-- =========================================================
-- 6. Duplicate latest run per day validation
-- =========================================================

\echo '2. Duplicate latest run per day validation'

WITH daily_run_check AS (
    SELECT
        snapshot_date,
        COUNT(*) AS latest_run_count
    FROM snapshot.vw_daily_latest_snapshot_run
    GROUP BY snapshot_date
)
SELECT
    COUNT(*) AS snapshot_date_count,
    COUNT(*) FILTER (WHERE latest_run_count <> 1) AS invalid_latest_run_date_count,
    CASE
        WHEN COUNT(*) FILTER (WHERE latest_run_count <> 1) = 0 THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM daily_run_check;

-- =========================================================
-- 7. Daily latest status row count validation
-- =========================================================

\echo '3. Daily latest status row count validation'

SELECT
    r.snapshot_date,
    r.snapshot_run_id,
    r.total_snapshot_rows AS expected_row_count,
    COUNT(s.bc_number) AS actual_row_count,
    CASE
        WHEN COUNT(s.bc_number) = r.total_snapshot_rows THEN 'PASS'
        ELSE 'NEEDS REVISION'
    END AS validation_result
FROM snapshot.vw_daily_latest_snapshot_run r
LEFT JOIN snapshot.vw_daily_status_snapshot_latest_per_day s
    ON r.snapshot_run_id = s.snapshot_run_id
GROUP BY
    r.snapshot_date,
    r.snapshot_run_id,
    r.total_snapshot_rows
ORDER BY
    r.snapshot_date;

-- =========================================================
-- 8. KPI preview validation
-- =========================================================

\echo '4. Daily KPI control latest-per-day preview'

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
    average_aging_open_bc
FROM snapshot.vw_daily_kpi_control_latest_per_day
ORDER BY snapshot_date;

\echo 'END Phase 11.1 - Create Daily Latest Snapshot Views'
