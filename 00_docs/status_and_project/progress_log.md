# Progress Log — Finance_Ops_Dev

**Project:** Finance_Ops_Dev  
**Repository:** finance_ops_dev
**GitHub Repository:** https://github.com/tanzildzikry/finance_ops_dev.git
**Document Type:** Cumulative Progress Log  
**Status:** ACTIVE / CUMULATIVE  
**Last Updated:** 2026-05-15  
**Current Phase:** Phase 12 — Power BI Semantic Model Build / Dashboard Baseline  

---

## 0. Current Status Snapshot

Current project status:

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW to MEDIUM
```

Reason:

The PostgreSQL reporting layer, Power BI semantic model structure, approved relationships, measure folders, current/control/reconciliation/movement guardrail measures, reconciliation status, SQL sort-order support, and Phase 12 dashboard blueprint are structurally aligned.

The project is not yet full PASS or production-ready because the following are still pending:

```text
Power BI visual page implementation
Slicer behavior validation
Drill-through behavior validation
Refresh validation
Report mapping validation
User final validation
```

---

## 1. Cumulative Progress Summary

This log is cumulative. Do not replace older progress with only the latest update.

The project has progressed through these major workstreams:

```text
1. Project setup and governance
2. Source preparation and data safety
3. PostgreSQL database and layer design
4. Raw-to-clean transformation and validation
5. Snapshot workflow and snapshot validation
6. Reporting view / curated Power BI source contract
7. Power BI semantic model contract
8. PBIX semantic model baseline
9. Canonical DAX measure setup
10. Reconciliation and control validation
11. SQL sort-order patch
12. Dashboard blueprint v1
13. Pending visual build and final validation
```

---

## 2. Project Setup and Governance

### Completed

- Defined project objective for Finance Operations dashboard development.
- Confirmed PostgreSQL as database layer.
- Confirmed Power BI as reporting/dashboard layer.
- Established public GitHub repo safety rule:
  - no real CSV,
  - no real customer names,
  - no real invoice data,
  - no credentials,
  - no `.env`,
  - no database dump,
  - no PBIX with embedded real/sensitive data.
- Established documentation-first workflow.
- Established validation-first workflow for SQL, DAX, semantic model, and report build.
- Confirmed user remains final validator.
- Confirmed project must not be called production-ready until schema, validation, reconciliation, refresh, report mapping, and user validation are complete.

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW
```

Reason:

Governance and documentation direction are clear, but final production readiness is not yet reached.

---

## 3. Business Scope and Guardrails

### Confirmed Scope

Current dashboard scope:

```text
Unbilled Monitoring
Executive Overview
AR Controller
PIC Operation Scoring / PIC Pressure Mapping
Daily Snapshot
Data Quality / Exception Control
Issue and Blocker Analysis
```

### Explicitly Out of Scope

Do not create actual business claims for:

```text
Actual cashflow
Actual cash-in
DSO
Collection performance
Payment overdue final
Cash receipt forecast
```

unless cash-in / cash receipt data becomes available.

### Active Business Rules

```text
RAB = Revenue / planned billable amount.
High risk = aging > 60 and RAB >= 3,000,000,000.
Use is_open_unbilled for open backlog.
Use open_rab_exposure_amount for open exposure.
REPORTED is excluded from active backlog.
UNCLASSIFIED is correction bucket, not PIC performance penalty.
DATELINE KE AR is excluded.
Source date format = MM/DD/YYYY.
event_category currently means PIC division.
event_status = ENDED or ON GOING based on event_end_date vs today.
Actual cashflow is out of scope until cash-in data exists.
```

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW
```

Reason:

Business rules are clear and must be preserved in SQL, DAX, semantic model, and dashboard visuals.

---

## 4. Source Preparation and Data Safety

### Completed

- Public repository safety rules were established.
- Masked sample approach confirmed.
- Real operational data must not be uploaded to public GitHub.
- GitHub is used for:
  - documentation,
  - SQL scripts,
  - DAX scripts,
  - validation scripts,
  - synthetic or masked samples only.

### Current Control

```text
Validation Result: PASS
Risk Level: LOW
```

Reason:

Repo safety rules are understood and active. Continue avoiding real data and credentials.

---

## 5. PostgreSQL Layering and Database Direction

### Completed

The recommended layer mindset was established:

```text
00_source
01_raw
02_clean
03_staging
04_core
05_mart
06_reporting
07_documentary
```

For current Phase 12 Power BI work, the active consumption layer is:

```text
06_reporting / reporting.*
```

Power BI must consume curated reporting views only.

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW
```

Reason:

Layering direction is stable. Power BI should not consume raw, clean, or base snapshot tables directly.

---

## 6. Raw-to-Clean Transformation and Validation

### Completed

Historical raw-to-clean workflow was established:

```text
Load CSV to raw
Run raw-to-clean transform
Run raw-clean validation
Run snapshot function
Run snapshot validation
Refresh Power BI
```

Known validation themes:

```text
row count reconciliation
BC key integrity
PIC key integrity
date parsing
amount validation
billing logic
REPORTED exclusion
UNCLASSIFIED handling
snapshot row count validation
DAX and Power BI reconciliation
```

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW to MEDIUM
```

Reason:

Current Power BI baseline relies on reporting views derived from validated snapshot/reporting logic. Continue validating row counts after every patch.

---

## 7. Snapshot Workflow

### Completed

Snapshot workflow was defined with the command:

```sql
SELECT snapshot.run_bc_daily_snapshot(CURRENT_DATE, '1600_WIB', 'daily_csv_upload');
```

Snapshot concepts were separated:

```text
ACTUAL_DAILY_SNAPSHOT
ESTIMATED_HISTORICAL_RECONSTRUCTION
CURRENT_LATEST_STATUS
```

Daily movement rule confirmed:

```text
Daily movement is meaningful only after at least two latest-per-day snapshot dates.
```

### Current Movement Status

```text
Movement table is structurally available.
Movement trend is not ready for business interpretation until latest-per-day snapshot dates >= 2.
```

### Current Control

```text
Validation Result: NEEDS REVIEW
Risk Level: LOW
```

Reason:

Movement structure exists, but movement trend insight remains blocked until enough snapshot dates are available.

---

## 8. Reporting Source Contract for Power BI

### Completed

Power BI source contract was locked to curated reporting views only:

```text
reporting.fact_current_bc
reporting.fact_movement_bc
reporting.fact_issue_current
reporting.control_current_kpi
reporting.control_movement_kpi
reporting.dim_pic
reporting.dim_bc
reporting.dim_date
```

Do not load into main PBIX:

```text
raw.*
clean.clean_bc
snapshot.bc_daily_status_snapshot
snapshot.bc_daily_issue_history
```

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW
```

Reason:

The PBIX baseline follows curated reporting views only.

---

## 9. Phase 12 Documentation Progress

### Completed Documents

The following Phase 12 documents were created or registered:

```text
phase_12_powerbi_naming_relationship_and_measure_contract.md
phase_12_pbix_build_validation_notes.md
phase_12_dashboard_blueprint_v1.md
```

The Phase 12 README was updated to register new documents.

### Current Active Dashboard Blueprint

Active visual execution baseline:

```text
phase_12_dashboard_blueprint_v1.md
```

Recommended Phase 12 page order:

```text
00_Reconciliation_Check
01_Executive_Control_Tower
02_AR_Action_Board
03_PIC_Pressure_Map
04_Issue_Drilldown
05_Movement_Readiness
```

Design flow:

```text
Trust → Exposure → Action → Ownership → Issue → Movement Readiness
```

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW
```

Reason:

Documentation is aligned with current semantic model state and next dashboard build direction.

---

## 10. Power BI Semantic Model Baseline

### Completed

PBIX semantic model baseline was built using curated `reporting.*` views only.

Loaded tables:

```text
fact_current_bc
fact_movement_bc
fact_issue_current
control_current_kpi
control_movement_kpi
dim_pic
dim_bc
dim_date
_measures
```

Target contract names remain:

```text
Fact_Current_BC
Fact_Movement_BC
Fact_Issue_Current
Control_Current_KPI
Control_Movement_KPI
Dim_PIC
Dim_BC
Dim_Date
_Measures
```

Current PBIX may still use lowercase table names. If so, DAX must follow actual PBIX names until safe rename is completed.

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW to MEDIUM
```

Reason:

The model is structurally aligned. Naming cleanup can be performed later before visual pages become too complex.

---

## 11. Power BI Relationship Progress

### Completed

Approved relationships implemented:

```text
Dim_PIC[pic_code]        → Fact_Current_BC[pic_internal_code]
Dim_PIC[pic_code]        → Fact_Movement_BC[pic_internal_code]
Dim_BC[bc_number]        → Fact_Current_BC[bc_number]
Dim_BC[bc_number]        → Fact_Movement_BC[bc_number]
Dim_BC[bc_number]        → Fact_Issue_Current[bc_number]
Dim_Date[date]           → Fact_Movement_BC[snapshot_date]
```

In the current lowercase PBIX, equivalent relationships are:

```text
dim_pic[pic_code]        → fact_current_bc[pic_internal_code]
dim_pic[pic_code]        → fact_movement_bc[pic_internal_code]
dim_bc[bc_number]        → fact_current_bc[bc_number]
dim_bc[bc_number]        → fact_movement_bc[bc_number]
dim_bc[bc_number]        → fact_issue_current[bc_number]
dim_date[date]           → fact_movement_bc[snapshot_date]
```

### Confirmed Relationship Rules

```text
No fact-to-fact relationship
No control table relationship
No bidirectional filter
No uncontrolled many-to-many relationship
No active Dim_Date relationship to Fact_Current_BC
```

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW
```

Reason:

Relationship setup is structurally correct. It still requires ongoing validation during visual build.

---

## 12. Power BI Measures Progress

### Completed Measure Table

Created DAX-only measure table:

```text
_Measures
```

or current lowercase equivalent:

```text
_measures
```

The dummy column was hidden.

### Created Display Folders

```text
01 Current KPI
02 Control KPI
03 Reconciliation
04 Movement Guardrail
```

### Current KPI Measures Created

```text
Current Total BC Count
Current Open BC Count
Current Open RAB Exposure
Current High Risk BC Count
Current High Risk RAB Exposure
Current Reported Excluded BC Count
Current UNCLASSIFIED PIC Count
Current Average Aging Open BC
Current Source Row Count
```

### Control KPI Measures Created

```text
Control Total BC Count
Control Open BC Count
Control Open RAB Exposure
Control High Risk BC Count
Control High Risk RAB Exposure
Control Reported Excluded BC Count
Control UNCLASSIFIED PIC Count
Control Average Aging Open BC
```

### Reconciliation Measures Created

```text
Recon Open BC Diff
Recon Open RAB Diff
Recon High Risk BC Diff
Recon High Risk RAB Diff
Recon Reported Excluded BC Diff
Recon UNCLASSIFIED PIC Diff
Recon Average Aging Diff
Recon KPI Status
```

### Movement Guardrail Measures Created

```text
Movement Readiness Flag
Movement Readiness Status
Movement Snapshot Date Count
```

### Current Reconciliation Result

```text
Recon KPI Status = PASS
```

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW
```

Reason:

Core measure layer is structurally complete and reconciliation status is PASS. Manual review reconciliation still needs follow-up if not yet implemented.

---

## 13. Reconciliation Logic Adjustment

### Completed

`Recon KPI Status` was adjusted to tolerate minor numeric artifacts.

Reason:

Power BI may display tiny decimal/floating point artifacts such as:

```text
7.11E-15
```

or small amount differences such as:

```text
0.03
```

These are not material compared with trillion-level RAB exposure.

Recommended tolerance:

```text
Amount diff tolerance: < 1
Average aging diff tolerance: < 0.0001
```

### Current Control

```text
Validation Result: PASS
Risk Level: LOW
```

Reason:

Reconciliation now reflects business materiality rather than failing on technical decimal artifacts.

---

## 14. Manual Review Measure Follow-Up

### Finding

Manual review was initially skipped because the wrong column name was assumed:

```text
manual_review_flag
```

The actual available field is:

```text
needs_manual_review_flag
```

Available in:

```text
fact_current_bc
fact_movement_bc
fact_issue_current
```

Control field exists:

```text
control_current_kpi[manual_review_bc_count]
```

### Recommended DAX

```DAX
Current Manual Review BC Count =
CALCULATE(
    COUNTROWS('fact_current_bc'),
    'fact_current_bc'[needs_manual_review_flag] = TRUE()
)
```

```DAX
Control Manual Review BC Count =
MAX('control_current_kpi'[manual_review_bc_count])
```

```DAX
Recon Manual Review BC Diff =
[Current Manual Review BC Count] - [Control Manual Review BC Count]
```

After adding these measures, update `Recon KPI Status` to include:

```text
ABS([Recon Manual Review BC Diff]) = 0
```

### Current Control

```text
Validation Result: NEEDS REVIEW
Risk Level: LOW
```

Reason:

The correct field is now identified, but PBIX must be updated if manual review reconciliation is not yet completed.

---

## 15. SQL Reporting View Sort-Order Patch

### Problem Found

Power BI calculated columns for sort order caused circular dependency when used with `Sort by column`.

### Decision

Move sort-order logic to SQL reporting views.

### Patched Views

```text
reporting.fact_current_bc
reporting.fact_movement_bc
reporting.fact_issue_current
```

### Added Sort Columns

For `reporting.fact_current_bc`:

```text
aging_bucket_order
risk_level_order
bc_closing_status_order
```

For `reporting.fact_movement_bc`:

```text
aging_bucket_order
risk_level_order
bc_closing_status_order
```

For `reporting.fact_issue_current`:

```text
invoice_completion_bucket_order
bc_closing_status_order
responsibility_type_order
issue_confidence_level_order
```

### SQL Validation Result

PostgreSQL validation result:

```text
reporting.fact_current_bc
row_count = 8266
aging_bucket_order_count = 8266
risk_level_order_count = 8266
bc_closing_status_order_count = 8266

reporting.fact_movement_bc
row_count = 8266
aging_bucket_order_count = 8266
risk_level_order_count = 8266
bc_closing_status_order_count = 8266

reporting.fact_issue_current
row_count = 8266
invoice_completion_bucket_order_count = 8266
bc_closing_status_order_count = 8266
responsibility_type_order_count = 8266
issue_confidence_level_order_count = 8266
```

### Current Control

```text
Validation Result: PASS
Risk Level: LOW
```

Reason:

Sort-order fields now exist in SQL reporting views and passed row count completeness validation.

---

## 16. Power BI Sort-by-Column Follow-Up

### Required Next PBIX Actions

After refreshing Power BI:

```text
fact_current_bc[aging_bucket] → fact_current_bc[aging_bucket_order]
fact_current_bc[risk_level] → fact_current_bc[risk_level_order]
fact_current_bc[bc_closing_status] → fact_current_bc[bc_closing_status_order]

fact_movement_bc[aging_bucket] → fact_movement_bc[aging_bucket_order]
fact_movement_bc[risk_level] → fact_movement_bc[risk_level_order]
fact_movement_bc[bc_closing_status] → fact_movement_bc[bc_closing_status_order]

fact_issue_current[invoice_completion_bucket] → fact_issue_current[invoice_completion_bucket_order]
fact_issue_current[bc_closing_status] → fact_issue_current[bc_closing_status_order]
fact_issue_current[responsibility_type] → fact_issue_current[responsibility_type_order]
fact_issue_current[issue_confidence_level] → fact_issue_current[issue_confidence_level_order]
```

Then hide all `_order` columns from report view.

### Current Control

```text
Validation Result: NEEDS REVIEW
Risk Level: LOW
```

Reason:

SQL patch is complete, but Power BI sort-by-column setup still needs to be applied after refresh.

---

## 17. Dashboard Blueprint v1

### Completed

Created:

```text
phase_12_dashboard_blueprint_v1.md
```

Registered it in:

```text
00_docs/phase_12/README.md
```

### Active Page Order

```text
00_Reconciliation_Check
01_Executive_Control_Tower
02_AR_Action_Board
03_PIC_Pressure_Map
04_Issue_Drilldown
05_Movement_Readiness
```

### Design Flow

```text
Trust → Exposure → Action → Ownership → Issue → Movement Readiness
```

### Rationale

The six-page blueprint is preferred for Phase 12 because it is:

```text
more model-ready
easier to validate
less likely to mislead users
aligned with current measures and relationships
more practical before movement trend readiness
```

The broader 8-page dashboard blueprint remains a strategic reference for later phases.

### Current Control

```text
Validation Result: NEEDS REVIEW
Risk Level: MEDIUM
```

Reason:

Blueprint is ready, but visual implementation and validation are pending.

---

## 18. Movement Status

### Current State

Movement table is structurally available.

Movement guardrail measures exist:

```text
Movement Readiness Flag
Movement Readiness Status
Movement Snapshot Date Count
```

### Active Rule

```text
Movement trend is not ready for business interpretation until latest-per-day snapshot dates >= 2.
```

### Allowed

```text
Movement readiness flag
Movement readiness status
Snapshot date count
Structure-only movement table
```

### Not Allowed Yet

```text
Movement trend interpretation
Open RAB movement insight
Open BC movement insight
Daily increase/decrease narrative
Management decision based on movement delta
```

### Current Control

```text
Validation Result: NEEDS REVIEW
Risk Level: LOW
```

Reason:

Movement readiness logic exists, but movement trend interpretation remains blocked.

---

## 19. Issue and Blocker Guardrail

### Active Rule

Do not classify issues from a single keyword only.

Example:

```text
PO sudah ada, proses upload iVendor
```

must be interpreted as:

```text
PO_AVAILABLE_IVENDOR_PROCESS
```

not:

```text
PO_NOT_ISSUED
```

Always distinguish:

```text
positive phrases
negative phrases
process phrases
unknown phrases
```

Confidence level must remain part of interpretation.

### Current Control

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW to MEDIUM
```

Reason:

Issue fields are available for dashboard use, but visual interpretation must preserve classifier guardrails.

---

## 20. Current Known Gaps

Pending work:

```text
Refresh PBIX after SQL sort-order patch.
Apply Sort by column using SQL-provided _order fields.
Hide _order columns.
Add manual review measures if not yet completed.
Update Recon KPI Status to include manual review reconciliation.
Hide technical/control/raw columns as appropriate.
Build 01_Executive_Control_Tower.
Build 02_AR_Action_Board.
Build 03_PIC_Pressure_Map.
Build 04_Issue_Drilldown.
Build 05_Movement_Readiness.
Validate page-level slicer behavior.
Validate issue drilldown behavior.
Validate movement readiness warning.
Validate refresh behavior.
Save PBIX baseline.
Update documentation after visual baseline is built.
User final validation.
```

---

## 21. Recommended Next Actions

Immediate next actions:

```text
1. Refresh Power BI after SQL sort-order patch.
2. Confirm _order columns appear.
3. Apply Sort by column.
4. Hide _order columns.
5. Add Manual Review measures if not yet completed.
6. Update Recon KPI Status to include manual review reconciliation.
7. Confirm Recon KPI Status remains PASS.
8. Start building 01_Executive_Control_Tower.
```

---

## 22. Current Validation Result

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW to MEDIUM
```

Reason:

The project is structurally aligned across SQL reporting views, Power BI relationships, DAX measure folders, reconciliation, movement guardrails, and dashboard blueprint.

Remaining risk comes from:

```text
visual implementation
slicer behavior
drill-through behavior
refresh validation
report mapping validation
user final validation
```

---

## 23. Production Readiness Note

Do not label the project production-ready yet.

Production-ready requires:

```text
schema validation
filter validation
grain validation
relationship validation
business rule validation
transform validation
snapshot validation
Power BI reconciliation
refresh validation
visual/report mapping validation
user final validation
```

User remains the final validator.
