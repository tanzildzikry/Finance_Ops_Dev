# Handover to New Chat v2 — Finance_Ops_Dev

**Project:** Finance_Ops_Dev  
**Document Type:** Handover / Continuity Note  
**Status:** ACTIVE  
**Last Updated:** 2026-05-15  
**Current Phase:** Phase 12 — Power BI Semantic Model Build / Dashboard Baseline  

---

## 1. Current Project Mode

Use:

```text
FINANCE_OPS_PROJECT MODE
```

The project is specifically about Finance_Ops_Dev, Unbilled Monitoring, AR Controller, PIC Operation Scoring / PIC Pressure Mapping, PostgreSQL snapshot/reporting layer, and Power BI semantic model/dashboard build.

Do not treat this as a general external model review.

---

## 2. Current Phase Status

The project is in:

```text
Phase 12 — Power BI Semantic Model Build / Dashboard Baseline
```

Current validation status:

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW to MEDIUM
```

Reason:

The semantic model baseline, approved relationships, core measure folders, current/control/reconciliation/movement guardrail measures, current vs control reconciliation, and SQL sort-order patch are structurally working.

The phase is not full PASS yet because dashboard visual pages, slicer behavior, drill-through behavior, refresh validation, and user final validation are not completed.

---

## 3. Current Source of Truth Documents

Use these as current authoritative Phase 12 references:

```text
00_docs/status_and_project/current_status.md
00_docs/status_and_project/progress_log.md
00_docs/status_and_project/handover_to_new_chat_v2.md
00_docs/phase_12/README.md
00_docs/phase_12/phase_12_powerbi_naming_relationship_and_measure_contract.md
00_docs/phase_12/phase_12_pbix_build_validation_notes.md
00_docs/phase_12/phase_12_dashboard_blueprint_v1.md
00_docs/phase_12/phase_12_semantic_model_blueprint.md
00_docs/phase_12/phase_12_relationship_matrix.md
00_docs/phase_12/phase_12_powerbi_validation_checklist.md
00_docs/phase_12/phase_12_measure_refactor_notes.md
```

Use `phase_12_dashboard_blueprint_v1.md` as the active visual execution baseline.

The broader uploaded dashboard blueprint can remain a strategic reference, but the Phase 12 execution baseline is the narrower six-page model-ready blueprint.

---

## 4. Current Power BI Load Contract

Power BI must load only curated reporting views:

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

GitHub is for:

```text
SQL scripts
DAX scripts
documentation
test checklist
project memory
```

Power BI data source is PostgreSQL, not GitHub.

---

## 5. Current Power BI Table Naming

Contract naming target:

```text
reporting.fact_current_bc      → Fact_Current_BC
reporting.fact_movement_bc     → Fact_Movement_BC
reporting.fact_issue_current   → Fact_Issue_Current
reporting.control_current_kpi  → Control_Current_KPI
reporting.control_movement_kpi → Control_Movement_KPI
reporting.dim_pic              → Dim_PIC
reporting.dim_bc               → Dim_BC
reporting.dim_date             → Dim_Date
DAX-only table                 → _Measures
```

Current PBIX may still use lowercase table names depending on implementation:

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

If the model still uses lowercase names, DAX should follow the actual PBIX table names until tables are safely renamed.

Rename can be done later, but preferably before dashboard pages become too complex.

---

## 6. Current Relationship Contract

Only these six relationships are allowed:

```text
Dim_PIC[pic_code]        → Fact_Current_BC[pic_internal_code]
Dim_PIC[pic_code]        → Fact_Movement_BC[pic_internal_code]
Dim_BC[bc_number]        → Fact_Current_BC[bc_number]
Dim_BC[bc_number]        → Fact_Movement_BC[bc_number]
Dim_BC[bc_number]        → Fact_Issue_Current[bc_number]
Dim_Date[date]           → Fact_Movement_BC[snapshot_date]
```

Rules:

```text
No fact-to-fact relationship.
No control table relationship.
No bidirectional filter.
No uncontrolled many-to-many relationship.
No active Dim_Date relationship to Fact_Current_BC.
```

Control tables must remain disconnected:

```text
Control_Current_KPI
Control_Movement_KPI
```

or lowercase equivalent:

```text
control_current_kpi
control_movement_kpi
```

---

## 7. Current Measure Structure

Measure table:

```text
_Measures
```

or lowercase equivalent:

```text
_measures
```

Measure folders already created:

```text
01 Current KPI
02 Control KPI
03 Reconciliation
04 Movement Guardrail
```

Current KPI measures created include:

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

Control KPI measures created include:

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

Reconciliation measures created include:

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

Movement guardrail measures created:

```text
Movement Readiness Flag
Movement Readiness Status
Movement Snapshot Date Count
```

Current reconciliation result:

```text
Recon KPI Status = PASS
```

---

## 8. Manual Review Measure Follow-Up

Manual review was initially skipped due to using the wrong column name.

The correct field exists:

```text
needs_manual_review_flag
```

Available in:

```text
fact_current_bc
fact_movement_bc
fact_issue_current
```

Control column exists:

```text
control_current_kpi[manual_review_bc_count]
```

Recommended next DAX:

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

Then update `Recon KPI Status` to include:

```text
ABS([Recon Manual Review BC Diff]) = 0
```

Status:

```text
Validation Result: NEEDS REVIEW
Risk Level: LOW
```

---

## 9. Reconciliation Logic

`Recon KPI Status` has been adjusted to tolerate minor numeric artifacts.

Reason:

Power BI can show tiny decimal/floating point artifacts such as:

```text
7.11E-15
```

or amount differences such as:

```text
0.03
```

These are not material when compared with trillion-level RAB exposure.

Recommended tolerance:

```text
Amount diff tolerance: < 1
Average aging diff tolerance: < 0.0001
```

Expected status:

```text
Recon KPI Status = PASS
```

---

## 10. SQL Sort-Order Patch

Sort order must come from SQL reporting views, not Power BI calculated columns.

Reason:

Power BI calculated sort columns caused circular dependency.

Patched views:

```text
reporting.fact_current_bc
reporting.fact_movement_bc
reporting.fact_issue_current
```

Added columns:

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

Validation result:

```text
fact_current_bc row_count = 8266
fact_movement_bc row_count = 8266
fact_issue_current row_count = 8266
All sort-order count checks = 8266
```

Status:

```text
Validation Result: PASS
Risk Level: LOW
```

Next Power BI action:

```text
Refresh PBIX.
Confirm _order columns appear.
Apply Sort by column.
Hide _order columns after sorting.
```

Sort mapping:

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

---

## 11. Active Dashboard Blueprint

Active Phase 12 dashboard blueprint:

```text
phase_12_dashboard_blueprint_v1.md
```

Use this page order:

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

Do not build the broader 8-page design first. That broader design is a strategic reference, not the current execution baseline.

---

## 12. Page Purpose Summary

### `00_Reconciliation_Check`

Purpose:

```text
Can we trust the Power BI numbers against SQL control?
```

Expected:

```text
Recon KPI Status = PASS
Movement Readiness Status = NOT READY until snapshot dates >= 2
```

### `01_Executive_Control_Tower`

Purpose:

```text
How much exposure is open, where is the risk, who owns the pressure, and which BCs need attention first?
```

Use current KPI measures only.

Do not use control measures here.

### `02_AR_Action_Board`

Purpose:

```text
Which BCs must be chased today and what is blocking them?
```

This is an operational follow-up page.

### `03_PIC_Pressure_Map`

Purpose:

```text
Show ownership and workload pressure, not final PIC performance scoring.
```

Use the term `PIC Pressure Map` for Phase 12 baseline.

Do not call it final PIC scoring yet.

### `04_Issue_Drilldown`

Purpose:

```text
Why is the BC not closing and who controls the blocker?
```

Use `fact_issue_current`.

### `05_Movement_Readiness`

Purpose:

```text
Is movement ready to be interpreted?
```

Do not show movement trend yet.

---

## 13. Movement Guardrail

Movement is structurally available, but not ready for business interpretation until:

```text
latest-per-day snapshot dates >= 2
```

Allowed:

```text
Movement Readiness Flag
Movement Readiness Status
Movement Snapshot Date Count
Structure-only movement table
```

Not allowed yet:

```text
Movement trend interpretation
Open RAB movement narrative
Open BC movement narrative
Daily increase/decrease conclusion
```

---

## 14. Business Rules to Preserve

Always preserve these Finance_Ops_Dev rules:

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

Do not create or show:

```text
Actual cashflow
Actual cash-in
DSO
Collection performance
Payment overdue final
Cash receipt forecast
```

unless cash-in/cash receipt data becomes available.

---

## 15. Issue Classifier Guardrail

Do not classify issue based on a single keyword only.

Example:

```text
PO sudah ada, proses upload iVendor
```

must be classified as:

```text
PO_AVAILABLE_IVENDOR_PROCESS
```

not:

```text
PO_NOT_ISSUED
```

Positive phrases must be detected before negative phrases.

Always distinguish:

```text
positive
negative
process
unknown
```

Include confidence level when interpreting issue/blocker fields.

---

## 16. Current Known Gaps

Pending work:

```text
Refresh Power BI after SQL sort-order patch.
Apply Sort by column.
Hide _order columns.
Add manual review measures if not yet completed.
Update Recon KPI Status to include manual review reconciliation.
Build visual pages from dashboard blueprint v1.
Validate slicer behavior.
Validate issue drilldown behavior.
Validate movement readiness page.
Hide technical/control/raw columns as appropriate.
Save PBIX baseline.
Validate refresh behavior.
User final validation.
```

Potential future enhancements:

```text
Dim_Customer
Dim_Event_Category
BC Case File Drillthrough
Full Movement Trend Page after snapshot readiness
PIC controllability scoring
Urgent/action priority refinement
```

---

## 17. Current Recommended Next Action

Recommended immediate next action:

```text
Refresh PBIX after SQL sort-order patch.
Apply Sort by column using SQL-provided _order columns.
Hide _order columns.
Add Manual Review measures and update Recon KPI Status.
Confirm Recon KPI Status remains PASS.
Then start 01_Executive_Control_Tower page build.
```

---

## 18. Current Validation Result

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW to MEDIUM
```

The project should not be labeled production-ready yet.

Production-ready requires:

```text
schema validation
relationship validation
KPI reconciliation
refresh validation
visual/report mapping validation
slicer behavior validation
drill-through validation
user final validation
```

User remains final validator.

