# Progress Log — Finance Ops Dev

## Current Status

Project: Finance_Ops_Dev  
Repository: finance_ops_dev  
Current Phase: Phase 3 — PostgreSQL Environment Setup  
Current Hold Point: After PostgreSQL database and schema validation  
Last Updated: 2026-05-14  

---

## Phase 0 — Project Safety Foundation

Status: PASS

Completed items:

- Repository will be private first.
- No real data is stored in the repository.
- Masked sample data is allowed.
- Masked sample column mapping is identical to the real project.
- Real project data remains in PostgreSQL or secure local folder.
- Repository folder is separated from real data folder.
- `.gitignore` created.
- `.env.example` created.
- Root `README.md` created.
- `DATA_SAFETY_CHECKLIST.md` created.
- `REPO_SCOPE.md` created.
- `03_sample_data_masked/README.md` created.
- Real PBIX files are blocked from repository.
- Real CSV / Excel files are blocked from repository.
- Database dumps are blocked from repository.
- Credentials and `.env` files are blocked from repository.

Committed files:

- `.gitignore`
- `.env.example`
- `README.md`
- `DATA_SAFETY_CHECKLIST.md`
- `REPO_SCOPE.md`
- `03_sample_data_masked/README.md`

Commit message:

```text
chore: initialize repo safety foundation

---

## Uncompleted Tasks / Next Action Backlog

### Phase 3 — PostgreSQL Environment Setup

Status: IN PROGRESS

Pending tasks:

- [ ] Create database setup validation script.
- [ ] Save database/schema validation SQL under `01_database/validation/`.
- [ ] Run validation script from PostgreSQL.
- [ ] Commit database validation script.
- [ ] Push database validation script to GitHub.
- [ ] Document final Phase 3 validation result.

### Phase 4 — Source / Masked Data Preparation

Status: NOT STARTED

Pending tasks:

- [ ] Prepare masked source files.
- [ ] Confirm masked source column mapping is identical to real project.
- [ ] Store masked source files only under `03_sample_data_masked/`.
- [ ] Document source file names and column mapping.
- [ ] Confirm no real customer, PIC, invoice, credential, or sensitive export exists in repo.
- [ ] Review amount field safety again before sharing repo externally.

### Phase 5 — Raw Layer Build

Status: NOT STARTED

Pending tasks:

- [ ] Create raw table DDL.
- [ ] Commit raw table DDL to `01_database/ddl/`.
- [ ] Load masked CSV into raw tables.
- [ ] Validate raw row count.
- [ ] Validate raw column count.
- [ ] Validate source date format.
- [ ] Document raw ingest result.

### Phase 6 — Clean Layer Build

Status: NOT STARTED

Pending tasks:

- [ ] Add raw-to-clean transform SQL.
- [ ] Standardize column names.
- [ ] Parse date fields using confirmed source format.
- [ ] Cast amount fields.
- [ ] Normalize status fields.
- [ ] Convert invalid/missing PIC to `UNCLASSIFIED` where applicable.
- [ ] Validate raw vs clean row count.
- [ ] Validate key integrity.
- [ ] Validate duplicate BC risk.
- [ ] Validate date parsing.
- [ ] Commit clean transform and validation scripts.

### Phase 7 — Snapshot Layer Build

Status: NOT STARTED

Pending tasks:

- [ ] Create snapshot tables.
- [ ] Create snapshot v1.1 fields.
- [ ] Add `is_open_unbilled`.
- [ ] Add `open_rab_exposure_amount`.
- [ ] Add `is_reported_excluded`.
- [ ] Add invoice completion fields.
- [ ] Add risk and manual review fields.
- [ ] Run snapshot function.
- [ ] Validate snapshot row count.
- [ ] Validate snapshot control fields.
- [ ] Commit snapshot DDL and validation scripts.

### Phase 8 — PostgreSQL Validation

Status: NOT STARTED

Pending tasks:

- [ ] Run raw-clean validation.
- [ ] Run snapshot validation.
- [ ] Run SQL test cases.
- [ ] Validate BC key integrity.
- [ ] Validate PIC key integrity.
- [ ] Validate amount fields.
- [ ] Validate billing logic.
- [ ] Validate invoice completion logic.
- [ ] Validate high risk logic.
- [ ] Validate REPORTED exclusion.
- [ ] Save validation results.

### Phase 9 — Approved SQL Examples

Status: NOT STARTED

Pending tasks:

- [ ] Add Executive KPI SQL.
- [ ] Add AR Controller SQL.
- [ ] Add Top High Risk BC SQL.
- [ ] Add PIC Score Base SQL.
- [ ] Add BC Investigation SQL.
- [ ] Add Data Quality SQL.
- [ ] Validate approved SQL examples in PostgreSQL.
- [ ] Commit approved SQL examples.

### Phase 10 — Power BI Connection

Status: NOT STARTED

Pending tasks:

- [ ] Open Power BI Desktop.
- [ ] Connect Power BI to PostgreSQL.
- [ ] Use Import Mode for first build.
- [ ] Load `snapshot.bc_daily_status_snapshot`.
- [ ] Load `snapshot.vw_daily_movement_summary`.
- [ ] Load `clean.clean_pic_list`.
- [ ] Create `dim_date`.
- [ ] Refresh data.
- [ ] Confirm PBIX is not committed if it contains embedded real data.

### Phase 11 — Power BI Semantic Model

Status: NOT STARTED

Pending tasks:

- [ ] Set `snapshot.bc_daily_status_snapshot` as main fact.
- [ ] Set `snapshot.vw_daily_movement_summary` as movement fact.
- [ ] Set `clean.clean_pic_list` as PIC dimension.
- [ ] Set `dim_date` as date dimension.
- [ ] Create date relationship to snapshot fact.
- [ ] Create date relationship to movement fact.
- [ ] Create PIC relationship.
- [ ] Set relationships to single direction.
- [ ] Avoid fact-to-fact relationship.
- [ ] Hide technical columns.
- [ ] Validate cardinality.

### Phase 12 — DAX Measure Build

Status: NOT STARTED

Pending tasks:

- [ ] Create measure table.
- [ ] Add Executive Overview measures.
- [ ] Add AR Controller measures.
- [ ] Add PIC Operation Scoring measures.
- [ ] Add Data Quality measures.
- [ ] Add Daily Movement measures.
- [ ] Use snapshot v1.1 fields.
- [ ] Use `is_open_unbilled` for open backlog.
- [ ] Use `open_rab_exposure_amount` for open exposure.
- [ ] Avoid `bill_status <> "BILLED"` as open logic.
- [ ] Save DAX library to repo.

### Phase 13 — Executive Overview Page

Status: NOT STARTED

Pending tasks:

- [ ] Create Total Open BC card.
- [ ] Create Open RAB Exposure card.
- [ ] Create High Risk BC Count card.
- [ ] Create High Risk RAB Exposure card.
- [ ] Create Average Aging Open BC card.
- [ ] Create UNCLASSIFIED PIC Count card.
- [ ] Create open exposure trend visual.
- [ ] Create aging bucket visual.
- [ ] Create top PIC risk visual.
- [ ] Create top high risk BC table.
- [ ] Validate page filters.

### Phase 14 — AR Controller Page

Status: NOT STARTED

Pending tasks:

- [ ] Create aging bucket analysis.
- [ ] Create invoice completion analysis.
- [ ] Create customer exposure ranking.
- [ ] Create document/blocker analysis.
- [ ] Create follow-up BC table.
- [ ] Add AR-focused slicers.
- [ ] Validate AR KPI logic.

### Phase 15 — PIC Operation Scoring Page

Status: NOT STARTED

Pending tasks:

- [ ] Create PIC ranking by open exposure.
- [ ] Create PIC ranking by high risk exposure.
- [ ] Create PIC average aging visual.
- [ ] Create manual review by PIC.
- [ ] Separate `UNCLASSIFIED` as correction bucket.
- [ ] Validate PIC relationship.
- [ ] Validate no many-to-many issue.

### Phase 16 — Data Quality / Exception Page

Status: NOT STARTED

Pending tasks:

- [ ] Create data quality KPI cards.
- [ ] Create manual review count.
- [ ] Create UNCLASSIFIED PIC count.
- [ ] Create partial invoice review table.
- [ ] Create over-invoiced review table.
- [ ] Create missing/invalid field exception table.
- [ ] Validate exception logic.

### Phase 17 — Power BI vs SQL Reconciliation

Status: NOT STARTED

Pending tasks:

- [ ] Run approved SQL Executive KPI.
- [ ] Compare SQL result with Power BI card values.
- [ ] Reconcile Total Open BC.
- [ ] Reconcile Open RAB Exposure.
- [ ] Reconcile High Risk BC Count.
- [ ] Reconcile High Risk RAB Exposure.
- [ ] Reconcile Average Aging Open BC.
- [ ] Reconcile UNCLASSIFIED PIC Count.
- [ ] Validate amount rounding.
- [ ] Validate snapshot date filter.
- [ ] Validate visual-level filters.
- [ ] Document mismatch if any.
- [ ] Fix DAX/model if mismatch.

### Phase 18 — Dashboard QA

Status: NOT STARTED

Pending tasks:

- [ ] Check slicers.
- [ ] Check filter direction.
- [ ] Check relationship behavior.
- [ ] Check blank values.
- [ ] Check duplicated BC risk.
- [ ] Check performance.
- [ ] Check refresh.
- [ ] Check visual naming.
- [ ] Check measure formatting.
- [ ] Check tooltip clarity.

### Phase 19 — Documentation

Status: NOT STARTED

Pending tasks:

- [ ] Document database architecture.
- [ ] Document semantic model.
- [ ] Document DAX measures.
- [ ] Document dashboard page mapping.
- [ ] Document KPI definitions.
- [ ] Document reconciliation result.
- [ ] Document known limitations.
- [ ] Document next improvement backlog.

### Phase 20 — Production Preparation

Status: NOT STARTED

Pending tasks:

- [ ] Configure scheduled PostgreSQL refresh.
- [ ] Configure snapshot daily routine.
- [ ] Configure Power BI refresh.
- [ ] Configure gateway if needed.
- [ ] Configure access control.
- [ ] Prepare deployment checklist.
- [ ] Prepare maintenance checklist.
- [ ] Prepare issue log.
- [ ] Prepare next sprint backlog.