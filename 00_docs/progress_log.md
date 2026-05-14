# Progress Log — Finance Ops Dev

## Current Status

Project: Finance_Ops_Dev  
Repository: finance_ops_dev  
GitHub Repository: https://github.com/tanzildzikry/finance_ops_dev.git  
Current Phase: Phase 9 — Snapshot Layer Build  
Current Hold Point: Phase 8 completed; clean layer validation passed and ready for snapshot layer build  
Last Updated: 2026-05-14  

Current validation result: PASS up to Phase 8  
Current risk level after control: LOW  
Production readiness: NOT YET  

---

## Project Scope

Current dashboard focus:

- Unbilled Monitoring
- Executive Overview
- AR Controller
- PIC Operation Scoring
- Daily Snapshot
- Data Quality / Exception Control

Current in-scope technical foundation:

- PostgreSQL database foundation
- Raw source ingestion
- Clean layer transform
- Clean layer validation
- Snapshot preparation
- SQL validation
- Power BI semantic model preparation
- DAX measure preparation
- SQL vs Power BI reconciliation

Out of scope for current dashboard:

- Actual cashflow
- Actual cash-in
- DSO
- Collection performance
- Payment overdue final

Cashflow will be handled later only after cash-in / cash receipt data exists.

---

## Active Business Rules

- RAB = Revenue / planned billable amount.
- High risk = aging > 60 and RAB >= 3,000,000,000.
- UNCLASSIFIED = PIC not input in ERP; correction bucket.
- UNCLASSIFIED is not a PIC performance penalty.
- REPORTED = excluded bucket, not active backlog.
- DATELINE KE AR = excluded.
- Source date format = MM/DD/YYYY.
- event_category currently means PIC division.
- event_status = ENDED or ON GOING based on event_end_date vs today.
- Actual cashflow is out of scope until cash-in data exists.

Closed / fully invoiced rule:

```text
bill_status = BILLED
AND invoice_number IS NOT NULL
AND invoice_completion_ratio >= 0.98
```

Preferred open backlog logic when snapshot v1.1 exists:

```text
is_open_unbilled = true
```

Preferred open exposure logic when snapshot v1.1 exists:

```text
open_rab_exposure_amount
```

---

## Project Execution Rules Updated During Build

### File Creation Rule

For creating or overwriting project files:

- Prioritize Python-based file writing.
- Avoid PowerShell `Set-Content` for SQL / Markdown files.
- Use UTF-8 without BOM.
- Avoid Linux/macOS heredoc syntax such as `python - <<'PY'` because the user is using Windows PowerShell.
- Do not provide scripts with placeholders such as `{target}`, `<USER>`, or `SQL CONTENT HERE`.
- If a path, file name, folder, or other required input is unknown, confirm it first before writing the script.
- For psql scripts, execute SQL files using `psql -f`.
- Do not paste SQL file content directly into PowerShell.

### psql / SQL File Rule

- `\copy` must be written as a one-line psql meta-command.
- Use `\set ON_ERROR_STOP on` for controlled failure.
- Use `psql.exe -f` to run `.sql` files.
- `pgAdmin Query Tool` is not used for scripts containing `\copy` or `\echo`.

---

## Repository Safety Rules

Allowed in GitHub:

- Masked sample data
- Synthetic sample data
- SQL DDL
- SQL transform
- SQL validation
- Approved SQL examples
- DAX measures
- Power BI documentation
- Semantic model documentation
- Dashboard mapping
- Test scripts
- Reconciliation checklist
- Markdown documentation

Not allowed in GitHub:

- Real CSV
- Real Excel
- Real customer data
- Real PIC data if sensitive
- Real invoice numbers
- Real confidential transaction files
- Database dumps
- `.env`
- Passwords
- Connection strings
- API keys
- Private keys
- PBIX files with embedded real data

Approved masked sample folder:

```text
03_sample_data_masked/
```

Control note:

```text
Amount fields are currently accepted by the user as safe, but must be reviewed again if the repository is shared externally or if repo visibility changes.
```

---

## Current Repository Structure

```text
00_docs/
  progress_log.md
  source_data_preparation.md
  source_file_register.md
  masked_source_review.md
  masked_source_profile_result.md

01_database/
  ddl/
    001_create_database_and_schemas.sql
    002_create_and_load_raw_source_tables.sql
  transform/
    003_transform_raw_to_clean.sql
  validation/
    001_validate_database_and_schemas.sql
    002_validate_raw_source_load.sql
    003_validate_clean_layer.sql
  snapshot/
  approved_sql_examples/

02_powerbi/
  dax/
  semantic_model/
  page_mapping/

03_sample_data_masked/
  README.md
  masked_bc_source_sample.csv
  masked_pic_list_sample.csv

04_python/
  issue_classifier/

05_tests/
  sql_tests/
  dax_tests/
  reconciliation_tests/
  source_file_profile_check.py

.env.example
.gitignore
DATA_SAFETY_CHECKLIST.md
README.md
REPO_SCOPE.md
```

---

# Phase 0 — Project Safety Foundation

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
```

Validation result: PASS  
Risk level after control: LOW

---

# Phase 1 — GitHub Repository Setup

Status: PASS

Completed items:

- Existing agent-build repository renamed to avoid naming conflict.
- New GitHub repository connected for Finance Ops Dev project.
- Local repository connected to GitHub remote.
- Initial commit pushed to GitHub.
- Repository visibility confirmed public after user updated visibility.

GitHub repository:

```text
https://github.com/tanzildzikry/finance_ops_dev.git
```

Remote validation:

```text
origin  https://github.com/tanzildzikry/finance_ops_dev.git (fetch)
origin  https://github.com/tanzildzikry/finance_ops_dev.git (push)
```

Validation result: PASS  
Risk level after control: LOW

---

# Phase 2 — Repository Structure

Status: PASS

Created folder structure:

```text
00_docs/
01_database/
  ddl/
  transform/
  validation/
  snapshot/
  approved_sql_examples/
02_powerbi/
  dax/
  semantic_model/
  page_mapping/
03_sample_data_masked/
04_python/
  issue_classifier/
05_tests/
  sql_tests/
  dax_tests/
  reconciliation_tests/
```

Placeholder `.gitkeep` files created for empty folders.

Commit message:

```text
chore: add project folder structure
```

Validation result: PASS  
Risk level after control: LOW

---

# Phase 3 — PostgreSQL Environment Setup

Status: PASS

## Phase 3.1 — PostgreSQL Installation Check

Status: PASS

Findings:

- PostgreSQL is installed.
- PostgreSQL version detected: PostgreSQL 18.3.
- `psql.exe` exists in:

```text
C:\Program Files\PostgreSQL\18\bin
```

Initial issue:

```text
psql : The term 'psql' is not recognized
```

Cause:

```text
PostgreSQL bin folder was not yet added to Windows PATH.
```

Resolution:

```text
C:\Program Files\PostgreSQL\18\bin
```

was added to user PATH.

Validation result: PASS  
Risk level after control: LOW

---

## Phase 3.2 — PostgreSQL Login Test

Status: PASS

Login command:

```bash
psql -U postgres
```

Validation result:

```text
postgres=#
```

Meaning:

```text
Login as PostgreSQL superuser postgres was successful.
```

Control note:

```text
Windows console code page warning appeared but does not block database setup.
```

Validation result: PASS  
Risk level after control: LOW

---

## Phase 3.3 — Database and Schema Setup Script

Status: PASS

Created SQL file:

```text
01_database/ddl/001_create_database_and_schemas.sql
```

Purpose:

- Create project database.
- Create controlled schemas.
- Prepare PostgreSQL foundation for raw, clean, snapshot, mart, reporting, and documentary layers.

Commit message:

```text
feat: add database and schema setup script
```

Validation result: PASS  
Risk level after control: LOW

---

## Phase 3.4 — Database and Schema Execution

Status: PASS

Database created:

```text
finance_ops_dev
```

Schemas created:

```text
raw
clean
snapshot
mart
reporting
documentary
```

Validation SQL:

```sql
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN (
    'raw',
    'clean',
    'snapshot',
    'mart',
    'reporting',
    'documentary'
)
ORDER BY schema_name;
```

Validation result:

```text
schema_name
-----------
clean
documentary
mart
raw
reporting
snapshot

(6 rows)
```

Validation result: PASS  
Risk level after control: LOW

---

## Phase 3.5 — Database Setup Validation Script

Status: PASS

Created validation SQL file:

```text
01_database/validation/001_validate_database_and_schemas.sql
```

Validation purpose:

- Confirm current database.
- Validate required schema existence.
- Validate required schema count.
- Produce final Phase 3 database foundation validation result.

Expected database:

```text
finance_ops_dev
```

Expected schemas:

```text
raw
clean
snapshot
mart
reporting
documentary
```

Final validation result:

```text
PASS
```

Commit message:

```text
test: add database and schema validation script
```

Validation result: PASS  
Risk level after control: LOW

---

# Phase 4 — Source / Masked Data Preparation

Status: PASS

Completed items:

- `source_data_preparation.md` created.
- `source_file_register.md` created.
- Masked source files added.
- `masked_source_review.md` created.
- Python source profile script created.
- Masked source profile result generated.
- Source files confirmed under approved masked folder.
- File profile checked:
  - file existence
  - file size
  - delimiter
  - header count
  - row count
  - duplicate header count
  - header list

Masked files added:

```text
03_sample_data_masked/masked_bc_source_sample.csv
03_sample_data_masked/masked_pic_list_sample.csv
```

Profile script:

```text
05_tests/source_file_profile_check.py
```

Profile result:

```text
00_docs/masked_source_profile_result.md
```

Source profile result:

| Source File | Row Count | Header Count | Duplicate Header Count | Validation Result | Risk Level |
|---|---:|---:|---:|---|---|
| masked_bc_source_sample.csv | 8266 | 27 | 0 | PASS | LOW |
| masked_pic_list_sample.csv | 69 | 4 | 0 | PASS | LOW |

BC source expected headers:

```text
NO
EVENT NAME
CUSTOMER
EVENT START DATE
EVENT END DATE
UNBILL AGING
EVENT STATUS
EVENT CATEGORY
PIC INTERNAL
BC NUMBER
NILAI
RAB
TOTAL TERINVOICE
UMK RELEASED
UMK ISSUED
PERIODE PENCATATAN
REMARKS
DOKUMEN KURANG
DATELINE KE AR
PIC USER
PO STATUS
UMK STATUS
BILL STATUS
INVOICE NUMBER
INVOICE DATE (LATEST)
CLOSING DURATION
HANDLING FEE
```

PIC source expected headers:

```text
Nama Lengkap
PIC
DIVISI
STATUS
```

Important note:

```text
PowerShell script was abandoned for source profiling because of parsing and encoding issues.
Python script is now the accepted approach for source profile checking.
```

Validation result: PASS  
Risk level after control: LOW

---

# Phase 5 — Raw Layer Build

Status: PASS

Completed items:

- Created raw source table load script.
- Created `raw.raw_bc_source`.
- Created `raw.raw_pic_list`.
- Used raw layer text-first approach.
- Loaded masked BC CSV into PostgreSQL raw table.
- Loaded masked PIC CSV into PostgreSQL raw table.
- Added source metadata columns:
  - `source_file_name`
  - `loaded_at`
- Debugged psql / PowerShell execution issue.
- Debugged `\copy` multiline issue.
- Finalized `\copy` as one-line psql meta-command.
- Added `\set ON_ERROR_STOP on` to stop script on load error.

Created file:

```text
01_database/ddl/002_create_and_load_raw_source_tables.sql
```

Active source paths:

```text
D:/Tanzil/AR COLLECTION/_DASHBOARD POWER BI/Bahan SQL + PBI/finance_ops_dev/Repo Finance_Ops_Dev/03_sample_data_masked/masked_bc_source_sample.csv
```

```text
D:/Tanzil/AR COLLECTION/_DASHBOARD POWER BI/Bahan SQL + PBI/finance_ops_dev/Repo Finance_Ops_Dev/03_sample_data_masked/masked_pic_list_sample.csv
```

Final raw load result:

```text
raw.raw_bc_source = 8266 rows
raw.raw_pic_list  = 69 rows
```

Key integrity result:

```text
raw.raw_bc_source.bc_number | table_row_count 8266 | null_or_blank_count 0 | duplicate_count 0 | PASS
raw.raw_pic_list.pic_code   | table_row_count 69   | null_or_blank_count 0 | duplicate_count 0 | PASS
```

Metadata validation result:

```text
masked_bc_source_sample.csv | row_count 8266
masked_pic_list_sample.csv  | row_count 69
```

Issues resolved:

1. SQL script was initially pasted directly into PowerShell.
   - Result: PowerShell parse error on SQL comments.
   - Resolution: save SQL script as `.sql` file and run through `psql`.

2. `\copy` was initially written as multiline.
   - Result: `\copy: parse error at end of line`.
   - Resolution: write each `\copy` command as one full line.

3. Existing raw tables from previous attempt caused metadata mismatch.
   - Resolution: controlled reload with `DROP TABLE IF EXISTS` for raw tables in local development script.

Commit message:

```text
feat: add raw source table load script
```

Validation result: PASS  
Risk level after control: LOW

---

# Phase 6 — Raw Load Validation Script Separation

Status: PASS

Completed items:

- Created separate validation script for raw load.
- Validation can now be rerun without recreate/drop/load.
- Validated raw row count.
- Validated raw key integrity.
- Validated raw metadata.
- Validated raw column count.

Created file:

```text
01_database/validation/002_validate_raw_source_load.sql
```

Row count validation:

```text
raw.raw_bc_source | actual_row_count 8266 | expected_row_count 8266 | PASS
raw.raw_pic_list  | actual_row_count 69   | expected_row_count 69   | PASS
```

Key integrity validation:

```text
raw.raw_bc_source.bc_number | table_row_count 8266 | null_or_blank_count 0 | duplicate_count 0 | PASS
raw.raw_pic_list.pic_code   | table_row_count 69   | null_or_blank_count 0 | duplicate_count 0 | PASS
```

Metadata validation:

```text
masked_bc_source_sample.csv | row_count 8266
masked_pic_list_sample.csv  | row_count 69
```

Header / column count validation:

```text
raw.raw_bc_source | actual_column_count 29 | expected_column_count 29 | PASS
raw.raw_pic_list  | actual_column_count 6  | expected_column_count 6  | PASS
```

Column count note:

```text
Raw source BC has 27 source columns + 2 metadata columns = 29 columns.
Raw source PIC has 4 source columns + 2 metadata columns = 6 columns.
```

Commit message:

```text
test: add raw source load validation
```

Validation result: PASS  
Risk level after control: LOW

---

# Phase 7 — Clean Layer DDL + Raw-to-Clean Transform

Status: PASS

Completed items:

- Created raw-to-clean transform script.
- Created / patched `clean.clean_bc`.
- Created / patched `clean.clean_pic_list`.
- Used safe reload approach because existing `clean.clean_bc` had dependent views.
- Avoided `DROP TABLE ... CASCADE` to prevent deleting existing DQ and snapshot views.
- Patched existing clean tables using `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`.
- Reloaded clean tables from raw tables.
- Parsed source dates using MM/DD/YYYY.
- Converted amount fields from raw text to numeric.
- Converted aging and closing duration fields to integer.
- Normalized status fields to uppercase.
- Converted missing / invalid PIC values such as `#N/A`, `N/A`, `NA`, and blank to `UNCLASSIFIED`.
- Preserved metadata:
  - `source_file_name`
  - `loaded_at`
  - `cleaned_at`

Created file:

```text
01_database/transform/003_transform_raw_to_clean.sql
```

Important implementation note:

```text
The first transform version attempted DROP TABLE on clean.clean_bc.
PostgreSQL blocked the drop because dependent views already existed:
- clean.vw_dq_bc_key_check
- clean.vw_dq_bc_orphan_pic_check
- clean.vw_dq_bc_amount_check
- snapshot.vw_latest_bc_daily_status_snapshot

Decision:
Do not use DROP ... CASCADE because it could remove existing DQ and snapshot views.
Use safe reload instead:
- CREATE TABLE IF NOT EXISTS
- ALTER TABLE ADD COLUMN IF NOT EXISTS
- TRUNCATE
- INSERT from raw
```

Additional issue resolved:

```text
Existing clean tables did not contain newer metadata or target columns such as loaded_at and ar_deadline_or_merge_invoice_notes.
Resolution: safe reload v3 adds all required columns with ALTER TABLE ADD COLUMN IF NOT EXISTS before insert.
```

Final clean row count validation:

```text
clean.clean_bc       | actual_row_count 8266 | expected_row_count 8266 | PASS
clean.clean_pic_list | actual_row_count 69   | expected_row_count 69   | PASS
```

Control note:

```text
Phase 7 validates clean row count only.
Detailed clean data quality validation is handled in Phase 8.
```

Commit message:

```text
feat: add raw to clean transform
```

Validation result: PASS  
Risk level after control: LOW

---

# Phase 8 — Clean Layer Validation

Status: PASS

Completed items:

- Created clean layer validation script.
- Deleted / replaced earlier `003_validate_clean_layer.sql` file that contained UTF-8 BOM.
- Recreated validation file using Python writer with UTF-8 without BOM.
- Validated raw vs clean row count.
- Validated BC key integrity.
- Validated PIC key integrity.
- Validated duplicate BC risk.
- Validated date parsing.
- Validated amount negative checks.
- Validated PIC orphan check.
- Validated clean metadata.
- Validated clean layer final summary.

Created file:

```text
01_database/validation/003_validate_clean_layer.sql
```

Encoding control:

```text
Earlier attempt failed with:
ERROR: syntax error at or near "ï»¿"

Cause:
The SQL file contained UTF-8 BOM.

Resolution:
Delete old file and recreate using Python with encoding='utf-8' without BOM.
```

Raw vs clean row count validation:

```text
BC raw vs clean  | raw_row_count 8266 | clean_row_count 8266 | expected_row_count 8266 | PASS
PIC raw vs clean | raw_row_count 69   | clean_row_count 69   | expected_row_count 69   | PASS
```

Key integrity validation:

```text
clean.clean_bc.bc_number      | table_row_count 8266 | null_or_blank_count 0 | duplicate_count 0 | PASS
clean.clean_pic_list.pic_code | table_row_count 69   | null_or_blank_count 0 | duplicate_count 0 | PASS
```

Date parsing validation:

```text
event_end_date        | raw_non_blank_count 8266 | clean_parsed_count 8266 | parse_failed_count 0 | PASS
event_start_date      | raw_non_blank_count 8266 | clean_parsed_count 8266 | parse_failed_count 0 | PASS
latest_invoice_date   | raw_non_blank_count 7730 | clean_parsed_count 7730 | parse_failed_count 0 | PASS
recording_period_date | raw_non_blank_count 8193 | clean_parsed_count 8193 | parse_failed_count 0 | PASS
```

Clean layer final summary:

```text
bc_key_integrity      | PASS
negative_amount_check | PASS
pic_key_integrity     | PASS
pic_orphan_check      | PASS
row_count_bc          | PASS
row_count_pic         | PASS
```

Control note:

```text
Phase 8 output shared by user confirms core clean layer validation PASS.
Detailed distribution outputs for billing status and event status were generated by the script, but only the final summary and earlier date/key/row count sections were shared in chat.
No blocking issue was reported by psql after final summary.
```

Recommended commit message:

```text
test: add clean layer validation
```

Validation result: PASS  
Risk level after control: LOW

---

# Current PostgreSQL State

Database:

```text
finance_ops_dev
```

Schemas:

| Schema | Purpose |
|---|---|
| raw | Raw ingest layer. Stores source data with minimal transformation. |
| clean | Clean layer. Stores standardized, typed, and validated data. |
| snapshot | Snapshot layer. Stores daily BC status snapshot and issue history. |
| mart | Subject-area analytical tables. |
| reporting | Power BI-ready views and reporting outputs. |
| documentary | Data dictionary, validation logs, lineage, and documentation metadata. |

Current raw tables:

```text
raw.raw_bc_source
raw.raw_pic_list
```

Current clean tables:

```text
clean.clean_bc
clean.clean_pic_list
```

Current confirmed row counts:

```text
raw.raw_bc_source     = 8266
raw.raw_pic_list      = 69
clean.clean_bc        = 8266
clean.clean_pic_list  = 69
```

---

# Current Validation Summary

| Area | Status | Risk |
|---|---|---|
| Repo safety foundation | PASS | LOW |
| GitHub repository setup | PASS | LOW |
| Repository folder structure | PASS | LOW |
| PostgreSQL installation | PASS | LOW |
| PostgreSQL PATH / psql | PASS | LOW |
| PostgreSQL login | PASS | LOW |
| Database creation | PASS | LOW |
| Schema creation | PASS | LOW |
| Schema validation | PASS | LOW |
| Masked source profile | PASS | LOW |
| Raw table build | PASS | LOW |
| Raw CSV load | PASS | LOW |
| Raw load validation | PASS | LOW |
| Raw key integrity | PASS | LOW |
| Raw column count validation | PASS | LOW |
| Clean transform row count | PASS | LOW |
| Clean layer validation | PASS | LOW |
| Snapshot layer | NOT STARTED | MEDIUM |
| Snapshot validation | NOT STARTED | MEDIUM |
| Power BI connection | NOT STARTED | MEDIUM |
| Power BI semantic model | NOT STARTED | MEDIUM |
| DAX validation | NOT STARTED | MEDIUM |
| Power BI vs SQL reconciliation | NOT STARTED | MEDIUM |

---

# Current Hold Point

We are holding after:

```text
Phase 8 — Clean Layer Validation
```

Last validation result:

```text
Phase 8 Clean Layer Validation = PASS
```

Next recommended phase:

```text
Phase 9 — Snapshot Layer Build
```

---

# Phase 9 — Snapshot Layer Build

Status: NOT STARTED

Pending tasks:

- [ ] Create snapshot tables.
- [ ] Create snapshot v1.1 fields.
- [ ] Add `is_open_unbilled`.
- [ ] Add `open_rab_exposure_amount`.
- [ ] Add `is_reported_excluded`.
- [ ] Add invoice completion fields.
- [ ] Add risk and manual review fields.
- [ ] Add data quality fields.
- [ ] Add issue source text.
- [ ] Add source row hash / record hash if required.
- [ ] Create snapshot run log.
- [ ] Run snapshot function.
- [ ] Validate snapshot row count.
- [ ] Validate snapshot control fields.
- [ ] Commit snapshot DDL and validation scripts.

Target table:

```text
snapshot.bc_daily_status_snapshot
```

Target issue history table:

```text
snapshot.bc_daily_issue_history
```

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 10 — Snapshot Validation

Status: NOT STARTED

Pending tasks:

- [ ] Run snapshot row count validation.
- [ ] Validate snapshot date.
- [ ] Validate snapshot run ID.
- [ ] Validate latest snapshot view.
- [ ] Validate `is_open_unbilled`.
- [ ] Validate `is_closed_fully_invoiced`.
- [ ] Validate `is_reported_excluded`.
- [ ] Validate `open_rab_exposure_amount`.
- [ ] Validate `invoice_gap_amount`.
- [ ] Validate `remaining_invoice_amount`.
- [ ] Validate high risk logic.
- [ ] Validate urgent flag logic.
- [ ] Validate manual review flag.
- [ ] Validate issue history row count.
- [ ] Validate daily movement readiness.

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 11 — Approved SQL Examples

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

Required rules:

- Use schema.table explicitly.
- Do not use `SELECT *` in final reporting queries.
- Use snapshot table for dashboard movement.
- Use clean table for latest/current validation.
- Exclude REPORTED from active open backlog.
- Use RAB as Revenue / planned billable amount.
- Use `open_rab_exposure_amount` when available.
- Use boolean flags from snapshot v1.1 when available.
- Do not create actual cashflow logic without cash-in data.

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 12 — Power BI Connection

Status: NOT STARTED

Pending tasks:

- [ ] Open Power BI Desktop.
- [ ] Connect Power BI to PostgreSQL.
- [ ] Use Import Mode for first build.
- [ ] Load `snapshot.bc_daily_status_snapshot`.
- [ ] Load `snapshot.vw_daily_movement_summary`.
- [ ] Load `clean.clean_pic_list`.
- [ ] Create or load `dim_date`.
- [ ] Refresh data.
- [ ] Confirm PBIX is not committed if it contains embedded real data.

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 13 — Power BI Semantic Model

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
- [ ] Validate filter direction.
- [ ] Validate no many-to-many issue unless explicitly bridged.

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 14 — DAX Measure Build

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
- [ ] Test DAX in actual PBIX.

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 15 — Executive Overview Page

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

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 16 — AR Controller Page

Status: NOT STARTED

Pending tasks:

- [ ] Create aging bucket analysis.
- [ ] Create invoice completion analysis.
- [ ] Create customer exposure ranking.
- [ ] Create document/blocker analysis.
- [ ] Create follow-up BC table.
- [ ] Add AR-focused slicers.
- [ ] Validate AR KPI logic.

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 17 — PIC Operation Scoring Page

Status: NOT STARTED

Pending tasks:

- [ ] Create PIC ranking by open exposure.
- [ ] Create PIC ranking by high risk exposure.
- [ ] Create PIC average aging visual.
- [ ] Create manual review by PIC.
- [ ] Separate `UNCLASSIFIED` as correction bucket.
- [ ] Validate PIC relationship.
- [ ] Validate no many-to-many issue.
- [ ] Ensure UNCLASSIFIED is not treated as PIC performance penalty.

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 18 — Data Quality / Exception Page

Status: NOT STARTED

Pending tasks:

- [ ] Create data quality KPI cards.
- [ ] Create manual review count.
- [ ] Create UNCLASSIFIED PIC count.
- [ ] Create partial invoice review table.
- [ ] Create over-invoiced review table.
- [ ] Create missing/invalid field exception table.
- [ ] Validate exception logic.

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 19 — Power BI vs SQL Reconciliation

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

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 20 — Dashboard QA

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

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Phase 21 — Documentation

Status: IN PROGRESS

Completed documentation:

- [x] Repo safety foundation documented.
- [x] Repository structure documented.
- [x] PostgreSQL setup documented.
- [x] Masked source profile documented.
- [x] Raw layer load documented.
- [x] Raw validation documented.
- [x] Clean row count transform documented.
- [x] Clean layer validation documented.

Pending documentation:

- [ ] Snapshot architecture.
- [ ] Snapshot validation result.
- [ ] Approved SQL examples.
- [ ] Power BI semantic model.
- [ ] DAX measures.
- [ ] Dashboard page mapping.
- [ ] KPI definitions.
- [ ] Reconciliation result.
- [ ] Known limitations.
- [ ] Next improvement backlog.

Validation result: IN PROGRESS  
Risk level before control: LOW

---

# Phase 22 — Production Preparation

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

Validation result: NOT STARTED  
Risk level before control: MEDIUM

---

# Important Safety Notes

- Real data must remain outside the repository.
- Masked sample data may be stored only under `03_sample_data_masked/`.
- `.env` must not be committed.
- `.env.example` is allowed.
- PBIX files with embedded real data must not be committed.
- Database dumps must not be committed.
- Connection strings must not be committed.
- Passwords and credentials must not be committed.
- Amount fields are currently accepted as safe by user confirmation, but must be reviewed again if repository visibility changes or the repository is shared externally.

---

# Known Issues Resolved

## Issue 1 — SQL pasted directly into PowerShell

Status: RESOLVED

Problem:

```text
PowerShell returned parser errors such as:
Missing expression after unary operator '--'
```

Cause:

```text
SQL script content was pasted directly into PowerShell instead of being saved as .sql and executed through psql.
```

Resolution:

```text
Save SQL script as .sql file and execute using psql -f.
```

---

## Issue 2 — psql `\copy` multiline parse error

Status: RESOLVED

Problem:

```text
\copy: parse error at end of line
```

Cause:

```text
psql meta-command \copy is line-based and should be written as one full line.
```

Resolution:

```text
Rewrite \copy commands as one-line commands.
```

---

## Issue 3 — Existing clean table blocked DROP

Status: RESOLVED

Problem:

```text
cannot drop table clean.clean_bc because other objects depend on it
```

Dependent objects included:

```text
clean.vw_dq_bc_key_check
clean.vw_dq_bc_orphan_pic_check
clean.vw_dq_bc_amount_check
snapshot.vw_latest_bc_daily_status_snapshot
```

Cause:

```text
Existing DQ and snapshot views depended on clean.clean_bc.
```

Resolution:

```text
Do not use DROP ... CASCADE.
Use safe reload with ALTER TABLE ADD COLUMN IF NOT EXISTS, TRUNCATE, then INSERT.
```

---

## Issue 4 — Existing clean tables missing new columns

Status: RESOLVED

Problem examples:

```text
column "loaded_at" of relation "clean_pic_list" does not exist
column "ar_deadline_or_merge_invoice_notes" of relation "clean_bc" does not exist
```

Cause:

```text
Clean tables already existed from previous version and did not include all target columns.
CREATE TABLE IF NOT EXISTS did not patch existing structure.
```

Resolution:

```text
Patch all required target columns using ALTER TABLE ADD COLUMN IF NOT EXISTS.
```

---

## Issue 5 — UTF-8 BOM in SQL validation file

Status: RESOLVED

Problem:

```text
ERROR: syntax error at or near "ï»¿"
LINE 1: ï»¿-- SQL content here
```

Cause:

```text
File was written with UTF-8 BOM / incorrect initial content.
PostgreSQL read BOM as invalid SQL characters.
```

Resolution:

```text
Delete the file and recreate it using Python with encoding='utf-8' without BOM.
```

---

# Current Production Readiness

Current production readiness:

```text
NOT YET
```

Reason:

- Raw tables are created and loaded.
- Clean transform is complete and validated.
- Detailed clean validation is PASS.
- Snapshot layer is not yet built in the current repo flow.
- Snapshot v1.1 validation has not yet been rerun in this current repo flow.
- Power BI has not yet been connected.
- Semantic model has not yet been validated.
- DAX measures have not yet been tested in actual PBIX.
- Power BI vs SQL reconciliation has not yet been performed.
- User final validation is not yet complete.

Current validation role:

```text
Foundation, source profile, raw layer, raw validation, clean transform, and clean validation are validated.
Snapshot validation, Power BI validation, and reconciliation are still pending.
```

---

# Next Action

Next phase:

```text
Phase 9 — Snapshot Layer Build
```

Immediate next file to create:

```text
01_database/snapshot/004_create_snapshot_layer.sql
```

Immediate next validation focus:

- snapshot table structure
- invoice completion logic
- open backlog logic
- REPORTED exclusion logic
- UNCLASSIFIED correction bucket
- high risk flag
- open RAB exposure amount
- data quality and manual review flags
- snapshot row count vs clean row count

Expected next validation result target:

```text
PASS or NEEDS REVIEW with documented exceptions
```

---

# Latest Validation Result

Validation result:

```text
PASS up to Phase 8
```

Risk level:

```text
LOW after Phase 8 controls
```

Next phase risk before control:

```text
MEDIUM for Phase 9 Snapshot Layer Build
```
