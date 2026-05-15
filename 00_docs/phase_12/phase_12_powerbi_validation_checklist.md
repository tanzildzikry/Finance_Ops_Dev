# Phase 12 Power BI Validation Checklist — Finance_Ops_Dev

## Status

Phase: 12  
Status: IN PROGRESS  
Validation Result: NEEDS REVIEW  
Risk Level: LOW  

---

## SQL Validation

- [ ] reporting schema exists
- [ ] reporting.fact_current_bc exists
- [ ] reporting.fact_movement_bc exists
- [ ] reporting.fact_issue_current exists
- [ ] reporting.control_current_kpi exists
- [ ] reporting.control_movement_kpi exists
- [ ] reporting.dim_pic exists
- [ ] reporting.dim_bc exists
- [ ] reporting.dim_date exists or Power BI date table is created

---

## Grain Validation

- [ ] Fact_Current_BC has one row per bc_number
- [ ] Fact_Movement_BC has one row per snapshot_date + bc_number
- [ ] Fact_Issue_Current has expected grain for issue drill-through
- [ ] Dim_PIC has unique pic_code
- [ ] Dim_BC has unique bc_number
- [ ] Dim_Date has unique date

---

## Relationship Validation

- [ ] Dim_PIC to Fact_Current_BC is 1:* single direction active
- [ ] Dim_PIC to Fact_Movement_BC is 1:* single direction active
- [ ] Dim_BC to Fact_Current_BC is 1:* single direction active
- [ ] Dim_BC to Fact_Movement_BC is 1:* single direction active
- [ ] Dim_BC to Fact_Issue_Current is 1:* single direction active
- [ ] Dim_Date to Fact_Movement_BC is 1:* single direction active
- [ ] No active fact-to-fact relationship
- [ ] No relationship from Control_Current_KPI
- [ ] No relationship from Control_Movement_KPI
- [ ] No bidirectional relationship
- [ ] No uncontrolled many-to-many relationship

---

## KPI Reconciliation

- [ ] Current Total BC Count reconciles to Control_Current_KPI
- [ ] Current Open BC Count reconciles to Control_Current_KPI
- [ ] Current Open RAB Exposure reconciles to Control_Current_KPI
- [ ] Current High Risk BC Count reconciles to Control_Current_KPI
- [ ] Current High Risk RAB Exposure reconciles to Control_Current_KPI
- [ ] Current Reported Excluded BC Count reconciles to Control_Current_KPI
- [ ] Current UNCLASSIFIED PIC Count reconciles to Control_Current_KPI
- [ ] Current Manual Review BC Count reconciles to Control_Current_KPI
- [ ] Current Average Aging Open BC reconciles to Control_Current_KPI

---

## Movement Guardrail

- [ ] Movement Readiness Flag exists
- [ ] Movement Readiness Status exists
- [ ] Movement page shows structure-only warning if distinct_snapshot_dates < 2
- [ ] Movement trend is not interpreted when distinct_snapshot_dates < 2

---

## DAX Validation

- [ ] Only canonical measures created
- [ ] No by-PIC measures
- [ ] No by-Customer measures
- [ ] No by-Division measures
- [ ] No duplicate synonym measures
- [ ] No open logic using billing_status <> "BILLED"
- [ ] No cashflow actual measure
- [ ] No DSO measure
- [ ] No collection performance final measure
- [ ] No payment overdue final measure

---

## Final Phase 12 PASS Criteria

Phase 12 can be marked PASS only when:
- SQL validation passes
- PBIX relationship validation passes
- KPI cards reconcile to control view
- movement readiness guardrail works
- user confirms final validation

---

## Phase 12 SQL Reporting Layer Validation Result

Marker: PHASE_12_SQL_VALIDATION_CHECKLIST_APPEND_2026_05_15

Updated: 2026-05-15

### SQL Reporting Layer Status

```text
PASS STRUCTURE ONLY
```

### Completed Checks

- [x] reporting.fact_current_bc exists
- [x] reporting.fact_movement_bc exists
- [x] reporting.fact_issue_current exists
- [x] reporting.control_current_kpi exists
- [x] reporting.control_movement_kpi exists
- [x] reporting.dim_pic exists
- [x] reporting.dim_bc exists
- [x] reporting.dim_date exists
- [x] Fact_Current_BC grain validated
- [x] Fact_Movement_BC grain validated
- [x] Fact_Issue_Current grain validated
- [x] Dim_PIC unique key validated
- [x] Dim_BC unique key validated
- [x] Dim_Date unique key validated
- [x] PIC orphan keys resolved
- [x] BC orphan keys resolved
- [x] Control_Current_KPI row count validated
- [x] Control_Movement_KPI row count validated
- [x] Current KPI reconciliation validated
- [x] Movement readiness validated as structure-only

### Remaining Checks

- [ ] Power BI tables loaded
- [ ] Power BI relationships created
- [ ] Power BI no fact-to-fact relationship validated
- [ ] Power BI no control relationship validated
- [ ] Power BI no bidirectional filter validated
- [ ] Power BI KPI cards reconciled
- [ ] Movement page guardrail applied
- [ ] User final validation completed
