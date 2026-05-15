# Phase 12 — PBIX Build Validation Notes

**Project:** Finance_Ops_Dev  
**Phase:** Phase 12 — Power BI Semantic Model Build / Relationship Setup  
**Document Type:** PBIX Build Validation Notes  
**Recommended File Name:** `phase_12_pbix_build_validation_notes.md`  
**Status:** ACTIVE VALIDATION NOTE  
**Validation Status:** PASS STRUCTURE ONLY  
**Risk Level:** LOW  

---

## 1. Purpose

This document records the current Power BI PBIX build validation result for Finance_Ops_Dev Phase 12.

The purpose is to document the semantic model baseline after:

1. Curated reporting views were loaded into Power BI.
2. Approved relationships were created.
3. `_measures` table was created.
4. Current KPI measures were created.
5. Control KPI measures were created.
6. Reconciliation measures were created.
7. Movement guardrail measures were created.
8. Current KPI values were reconciled against SQL control values.

This document does not declare full dashboard production readiness.

Full Phase 12 PASS still requires visual page validation, slicer validation, drill-through validation, and user final validation.

---

## 2. Validation Date

To be filled by user.

---

## 3. Scope

Power BI semantic model baseline for Finance_Ops_Dev Phase 12.

Validated scope:

1. Power BI table load structure.
2. Power BI relationship structure.
3. Disconnected control table rule.
4. `_measures` table setup.
5. Current KPI measures.
6. Control KPI measures.
7. Reconciliation measures.
8. Movement readiness guardrail.
9. Measure display folder organization.
10. Current vs Control KPI reconciliation.

Out of scope for this validation note:

1. Final dashboard visual design.
2. Final slicer behavior validation.
3. Drill-through page validation.
4. Final executive dashboard approval.
5. Production readiness sign-off.
6. Actual cashflow, cash-in, DSO, or collection performance.

---

## 4. Completed PBIX Setup

The following setup has been completed.

- Loaded curated reporting views only.
- Created `_measures` table.
- Created approved relationships only.
- Confirmed control tables remain disconnected.
- Created Current KPI measures.
- Created Control KPI measures.
- Created Reconciliation measures.
- Created Movement Guardrail measures.
- Organized measures into display folders:
  - `01 Current KPI`
  - `02 Control KPI`
  - `03 Reconciliation`
  - `04 Movement Guardrail`
- Created reconciliation validation page.
- Updated `Recon KPI Status` tolerance logic.
- Confirmed `Recon KPI Status` returns `PASS`.

---

## 5. Loaded Tables

The Power BI model should load only the curated reporting views below.

| PostgreSQL Source | Power BI Table Name | Status |
|---|---|---|
| `reporting.fact_current_bc` | `fact_current_bc` | Loaded |
| `reporting.fact_movement_bc` | `fact_movement_bc` | Loaded |
| `reporting.fact_issue_current` | `fact_issue_current` | Loaded |
| `reporting.control_current_kpi` | `control_current_kpi` | Loaded / disconnected |
| `reporting.control_movement_kpi` | `control_movement_kpi` | Loaded / disconnected |
| `reporting.dim_pic` | `dim_pic` | Loaded |
| `reporting.dim_bc` | `dim_bc` | Loaded |
| `reporting.dim_date` | `dim_date` | Loaded |

Control note:

The current PBIX table names are lowercase because they were imported from PostgreSQL using source naming.

This is acceptable for the current build as long as DAX references match actual imported table names.

The documented contract table names remain the preferred business-readable names for future cleanup:

- `Fact_Current_BC`
- `Fact_Movement_BC`
- `Fact_Issue_Current`
- `Control_Current_KPI`
- `Control_Movement_KPI`
- `Dim_PIC`
- `Dim_BC`
- `Dim_Date`

---

## 6. Relationship Validation

Status: PASS STRUCTURE ONLY

Approved relationships implemented:

| From | To | Cardinality | Direction | Active |
|---|---|---|---|---|
| `dim_pic[pic_code]` | `fact_current_bc[pic_internal_code]` | `1:*` | Single | Yes |
| `dim_pic[pic_code]` | `fact_movement_bc[pic_internal_code]` | `1:*` | Single | Yes |
| `dim_bc[bc_number]` | `fact_current_bc[bc_number]` | `1:*` | Single | Yes |
| `dim_bc[bc_number]` | `fact_movement_bc[bc_number]` | `1:*` | Single | Yes |
| `dim_bc[bc_number]` | `fact_issue_current[bc_number]` | `1:*` | Single | Yes |
| `dim_date[date]` | `fact_movement_bc[snapshot_date]` | `1:*` | Single | Yes |

Confirmed relationship rules:

- No fact-to-fact relationship.
- No control table relationship.
- No bidirectional relationship.
- No uncontrolled many-to-many relationship.
- No active `dim_date` relationship to `fact_current_bc`.

---

## 7. Control Table Validation

Status: PASS STRUCTURE ONLY

The following tables remain disconnected:

- `control_current_kpi`
- `control_movement_kpi`

Purpose:

- `control_current_kpi` is used as the current KPI reconciliation baseline.
- `control_movement_kpi` is reserved for movement KPI control and guardrail.

Control tables must not be used as slicers or filtering dimensions.

---

## 8. Measure Table Validation

Status: PASS STRUCTURE ONLY

A DAX-only measure container table has been created:

```text
_measures
```

The dummy column in `_measures` has been hidden.

Measures have been organized into display folders:

```text
01 Current KPI
02 Control KPI
03 Reconciliation
04 Movement Guardrail
```

---

## 9. Current KPI Measures

Status: PASS STRUCTURE ONLY

Created Current KPI measures:

- `Current Total BC Count`
- `Current Open BC Count`
- `Current Open RAB Exposure`
- `Current High Risk BC Count`
- `Current High Risk RAB Exposure`
- `Current Reported Excluded BC Count`
- `Current UNCLASSIFIED PIC Count`
- `Current Average Aging Open BC`
- `Current Source Row Count`

Manual review measure status:

- `Current Manual Review BC Count` was skipped.
- Reason: `manual_review_flag` is not available in `fact_current_bc`.

---

## 10. Control KPI Measures

Status: PASS STRUCTURE ONLY

Created Control KPI measures:

- `Control Total BC Count`
- `Control Open BC Count`
- `Control Open RAB Exposure`
- `Control High Risk BC Count`
- `Control High Risk RAB Exposure`
- `Control Reported Excluded BC Count`
- `Control UNCLASSIFIED PIC Count`
- `Control Average Aging Open BC`

Manual review control measure status:

- `Control Manual Review BC Count` was skipped.
- Reason: matching manual review field is not confirmed for the current reconciliation setup.

---

## 11. Reconciliation Measures

Status: PASS

Created Reconciliation measures:

- `Recon Open BC Diff`
- `Recon Open RAB Diff`
- `Recon High Risk BC Diff`
- `Recon High Risk RAB Diff`
- `Recon Reported Excluded BC Diff`
- `Recon UNCLASSIFIED PIC Diff`
- `Recon Average Aging Diff`
- `Recon KPI Status`

Validation result:

```text
Recon KPI Status = PASS
```

Notes:

- Current KPI and Control KPI are reconciled.
- Small decimal differences are treated as rounding artifacts.
- Amount tolerance is used for RAB exposure reconciliation.
- Average aging tolerance is used for decimal/floating point precision.

Current tolerance logic:

```text
Amount tolerance: ABS(diff) < 1
Average aging tolerance: ABS(diff) < 0.0001
```

Reason:

Very small decimal differences can occur due to numeric conversion or floating point precision between PostgreSQL and Power BI.

---

## 12. Movement Guardrail Measures

Status: PASS STRUCTURE ONLY

Created Movement Guardrail measures:

- `Movement Readiness Flag`
- `Movement Readiness Status`
- `Movement Snapshot Date Count`

Current movement condition:

```text
Movement source is structurally safe, but movement trend is not yet ready for business interpretation.
```

Movement readiness rule:

```text
Movement trend can be interpreted only when latest-per-day distinct snapshot dates >= 2.
```

Expected current status:

```text
Movement Readiness Status = NOT READY - movement requires at least 2 latest-per-day snapshot dates
```

---

## 13. Known Gap

### 13.1 Manual Review KPI

Manual Review KPI is currently skipped.

Reason:

```text
manual_review_flag is not available in fact_current_bc
```

Follow-up options:

1. Confirm whether the manual review field exists under another column name.
2. Add the manual review field to `reporting.fact_current_bc` if required.
3. Add matching control field logic if manual review KPI becomes part of the required Phase 12 validation scope.
4. Recreate Current, Control, and Recon Manual Review measures only after the source field is confirmed.

Current validation impact:

```text
Validation Result: NEEDS REVIEW for Manual Review KPI only
Risk Level: LOW
```

Reason:

Manual Review KPI is not blocking the current core reconciliation because it has been intentionally skipped and documented.

---

## 14. Validation Result

Current PBIX semantic model build status:

```text
Validation Result: PASS STRUCTURE ONLY
Risk Level: LOW
```

Reason:

The model structure, relationships, core KPI measures, control measures, reconciliation measures, and movement guardrail measures are in place and current vs control reconciliation returns PASS.

This is not yet full Phase 12 PASS.

---

## 15. Remaining Before Full Phase 12 PASS

The following items remain before full Phase 12 validation can be declared PASS:

1. Save PBIX baseline.
2. Validate executive overview page.
3. Validate AR Controller page.
4. Validate PIC Operation Scoring page.
5. Validate Issue Drill-through page.
6. Validate Movement Monitoring page structure.
7. Validate slicer behavior.
8. Validate drill-through behavior.
9. Validate visible KPI cards against SQL control values.
10. Validate no hidden relationship ambiguity.
11. Validate no additional non-approved tables were loaded.
12. Validate no additional non-approved relationships were created.
13. Confirm manual review KPI requirement.
14. User final validation.

---

## 16. Control Notes

Power BI remains a semantic and visualization layer.

Business logic must primarily come from PostgreSQL curated reporting views and snapshot fields.

DAX must stay simple, auditable, and aligned with SQL control outputs.

Do not create:

- Actual cashflow measures.
- Cash-in measures.
- DSO measures.
- Collection performance measures.
- Payment overdue final measures.
- Fact-to-fact relationship.
- Control table relationship.
- Bidirectional filter.
- Open backlog logic based only on `billing_status <> "BILLED"`.

Use:

- `is_open_unbilled` for open backlog.
- `open_rab_exposure_amount` for open exposure.
- disconnected control tables for reconciliation.
- movement readiness guardrail before interpreting movement.

---

## 17. Next Recommended Work

Next technical work should focus on visual page build and validation.

Recommended page order:

1. `00_Reconciliation_Check`
2. `01_Executive_Overview`
3. `02_AR_Controller`
4. `03_PIC_Operation_Scoring`
5. `04_Issue_Drillthrough`
6. `05_Movement_Monitoring`

Each page should be validated against the Phase 12 Power BI semantic model contract before being considered ready.
