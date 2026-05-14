# Handover to New Chat — Finance Ops Dev

## 1. Handover Purpose

This document is used to continue the Finance_Ops_Dev project in a new ChatGPT conversation without losing project context, purpose, progress, structure, rules, and next actions.

The new assistant must continue from the latest validated project state and must not restart from zero.

---

## 2. Project Identity

Project name:

```text
Finance_Ops_Dev
```

GitHub repository:

```text
https://github.com/tanzildzikry/finance_ops_dev.git
```

Main purpose:

```text
Build a controlled PostgreSQL + Power BI foundation for Finance Ops / Unbilled Monitoring using masked data.
```

Current dashboard focus:

```text
Unbilled Monitoring
Executive Overview
AR Controller
PIC Operation Scoring
Daily Snapshot
Data Quality / Exception Control
```

Current project mode:

```text
FINANCE_OPS_PROJECT MODE
```

---

## 3. Important Operating Rules

The assistant must follow Finance_Ops_Dev rules.

Core project rules:

- RAB = Revenue / planned billable amount.
- High risk = aging > 60 and RAB >= 3,000,000,000.
- UNCLASSIFIED = PIC not input in ERP; correction bucket.
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

Preferred open backlog logic:

```text
is_open_unbilled = true
```

Preferred open exposure logic:

```text
open_rab_exposure_amount
```

Do not use simplistic open logic such as:

```text
bill_status <> 'BILLED'
```

---

## 4. Data Safety Policy

Repository uses masked data only.

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

Accepted risk:

```text
Amount fields are currently accepted by the user as safe even if not masked.
If repo becomes public or externally shared, amount fields must be reviewed again.
```

---

## 5. Current Repository Structure

Current repo root:

```text
Repo Finance_Ops_Dev/
```

Current structure:

```text
00_docs/
  .gitkeep
  progress_log.md
  source_data_preparation.md
  source_file_register.md
  masked_source_review.md
  masked_source_profile_result.md

01_database/
  ddl/
    .gitkeep
    001_create_database_and_schemas.sql
  transform/
    .gitkeep
  validation/
    .gitkeep
    001_validate_database_and_schemas.sql
  snapshot/
    .gitkeep
  approved_sql_examples/
    .gitkeep

02_powerbi/
  dax/
    .gitkeep
  semantic_model/
    .gitkeep
  page_mapping/
    .gitkeep

03_sample_data_masked/
  README.md
  masked_bc_source_sample.csv
  masked_pic_list_sample.csv

04_python/
  issue_classifier/
    .gitkeep

05_tests/
  sql_tests/
    .gitkeep
  dax_tests/
    .gitkeep
  reconciliation_tests/
    .gitkeep
  source_file_profile_check.py

.env.example
.gitignore
DATA_SAFETY_CHECKLIST.md
README.md
REPO_SCOPE.md
```

---

## 6. Completed Progress Summary

### Phase 0 — Project Safety Foundation

Status:

```text
PASS
```

Completed:

- Repo safety policy created.
- `.gitignore` created.
- `.env.example` created.
- `README.md` created.
- `DATA_SAFETY_CHECKLIST.md` created.
- `REPO_SCOPE.md` created.
- `03_sample_data_masked/README.md` created.
- Real data separated from repo.
- PBIX, database dumps, `.env`, real CSV/Excel blocked from repo.

Commit message used:

```text
chore: initialize repo safety foundation
```

---

### Phase 1 — GitHub Repository Setup

Status:

```text
PASS
```

Completed:

- Existing agent-build repo renamed to avoid conflict.
- New GitHub repo connected.
- Local repo pushed to GitHub.

GitHub repo:

```text
https://github.com/tanzildzikry/finance_ops_dev.git
```

---

### Phase 2 — Repository Structure

Status:

```text
PASS
```

Completed:

- Standard folders created.
- `.gitkeep` placeholders added.
- Structure pushed to GitHub.

Commit message used:

```text
chore: add project folder structure
```

---

### Phase 3 — PostgreSQL Environment Setup

Status:

```text
PASS
```

Completed:

- PostgreSQL installed.
- PostgreSQL version: 18.3.
- `psql` PATH configured.
- Login as `postgres` successful.
- Database created:

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

Validation result:

```text
6 schemas found
PASS
```

SQL files created:

```text
01_database/ddl/001_create_database_and_schemas.sql
01_database/validation/001_validate_database_and_schemas.sql
```

Commit messages used:

```text
feat: add database and schema setup script
test: add database and schema validation script
docs: mark postgres environment setup as pass
```

---

### Phase 4 — Source / Masked Data Preparation

Status:

```text
IN PROGRESS
```

Completed so far:

- `source_data_preparation.md` created.
- `source_file_register.md` created.
- Masked source files added.
- `masked_source_review.md` created.
- Python source profile script created.
- Masked source profile result generated.

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

Latest completed command:

```bash
git add 05_tests/source_file_profile_check.py 00_docs/masked_source_profile_result.md
git commit -m "test: add masked source profile check"
git push
```

Important note:

PowerShell script was abandoned because of parsing and encoding issues. Python script is now the accepted approach.

---

## 7. Current PostgreSQL State

PostgreSQL database:

```text
finance_ops_dev
```

Current schemas:

| Schema | Purpose |
|---|---|
| raw | Raw ingest layer. Stores source data with minimal transformation. |
| clean | Clean layer. Stores standardized, typed, and validated data. |
| snapshot | Snapshot layer. Stores daily BC status snapshot and issue history. |
| mart | Subject-area analytical tables. |
| reporting | Power BI-ready views and reporting outputs. |
| documentary | Data dictionary, validation logs, lineage, and documentation metadata. |

Current validation script:

```text
01_database/validation/001_validate_database_and_schemas.sql
```

Current result:

```text
PASS
```

---

## 8. Current Git State Expected

At handover point, expected Git state should be clean after latest push.

Command:

```bash
git status
```

Expected:

```text
On branch main
Your branch is up to date with 'origin/main'.
nothing to commit, working tree clean
```

If not clean, review files before continuing.

---

## 9. Current Hold Point

Current hold point:

```text
After Phase 4.5 — Masked source profile check
```

Next recommended action:

```text
Review masked_source_profile_result.md and confirm whether Phase 4 can be marked PASS.
```

Then continue to:

```text
Phase 5 — Raw Layer Build
```

---

## 10. Immediate Next Steps

### Step 1 — Confirm source profile result

Open:

```text
00_docs/masked_source_profile_result.md
```

Check:

```text
Final Validation Result
```

Expected:

```text
PASS
```

Also check:

- row count for `masked_bc_source_sample.csv`
- header count for `masked_bc_source_sample.csv`
- row count for `masked_pic_list_sample.csv`
- header count for `masked_pic_list_sample.csv`
- duplicate header count = 0

### Step 2 — Update progress_log.md

If profile result is PASS, update:

```text
00_docs/progress_log.md
```

Set Phase 4.5 as PASS.

### Step 3 — Start Phase 5

Phase 5 target:

```text
Raw Layer Build
```

Main tasks:

- Create raw table DDL.
- Use CSV profile result to determine raw column structure.
- Create `raw.raw_bc_source`.
- Create `raw.raw_pic_list`.
- Load masked CSV into raw tables.
- Validate row count.
- Validate column count.
- Validate source date format.
- Document raw ingest result.

---

## 11. Recommended Files to Upload in New Chat

In the new chat, upload these files first:

### Must upload

```text
00_docs/progress_log.md
00_docs/source_data_preparation.md
00_docs/source_file_register.md
00_docs/masked_source_review.md
00_docs/masked_source_profile_result.md
01_database/ddl/001_create_database_and_schemas.sql
01_database/validation/001_validate_database_and_schemas.sql
05_tests/source_file_profile_check.py
```

### Upload if continuing to Phase 5 Raw Layer Build

```text
03_sample_data_masked/masked_bc_source_sample.csv
03_sample_data_masked/masked_pic_list_sample.csv
```

### Optional but useful

```text
README.md
REPO_SCOPE.md
DATA_SAFETY_CHECKLIST.md
.gitignore
.env.example
```

### Also provide GitHub repo link

Yes, include the GitHub link in the new chat:

```text
https://github.com/tanzildzikry/finance_ops_dev.git
```

Important:

If ChatGPT in the new chat cannot access GitHub directly, upload the files manually.

---

## 12. Suggested Opening Prompt for New Chat

Use this prompt in the new chat:

```text
Saya ingin melanjutkan project Finance_Ops_Dev dari handover ini.

Project mode: FINANCE_OPS_PROJECT MODE.

GitHub repo:
https://github.com/tanzildzikry/finance_ops_dev.git

Current status:
- Phase 0 Repo Safety Foundation = PASS
- Phase 1 GitHub Setup = PASS
- Phase 2 Repository Structure = PASS
- Phase 3 PostgreSQL Environment Setup = PASS
- Phase 4 Source / Masked Data Preparation = IN PROGRESS
- Latest completed step: masked source files added and Python source profile check created
- Current hold point: review masked_source_profile_result.md, then mark Phase 4.5 PASS and continue to Phase 5 Raw Layer Build

Please continue using Finance_Ops_Dev business rules:
- RAB = Revenue / planned billable amount
- High risk = aging > 60 and RAB >= 3,000,000,000
- UNCLASSIFIED = correction bucket, not PIC penalty
- REPORTED = excluded from active backlog
- Source date format = MM/DD/YYYY
- Actual cashflow is out of scope until cash-in data exists
- Use is_open_unbilled for open backlog when snapshot v1.1 exists
- Use open_rab_exposure_amount for open exposure when snapshot v1.1 exists

Please do not restart from zero.
Please first read the uploaded handover and progress files, then summarize current state, validation status, risk, and next action.
```

---

## 13. Validation Philosophy for New Chat

The assistant must continue with this output style:

```text
KONDISI —
PENYEBAB —
KONTROL —
AKSI —
VALIDATION RESULT —
```

Validation results allowed:

```text
PASS
NEEDS REVIEW
NEEDS REVISION
BLOCKED
```

Risk levels:

```text
LOW
MEDIUM
HIGH
CRITICAL
```

---

## 14. Critical Warnings for Continuation

Do not claim production-ready yet.

Production readiness is still:

```text
NOT YET
```

Reasons:

- Raw tables not yet created.
- Masked source not yet loaded into PostgreSQL raw tables.
- Raw to clean transform not yet implemented in this repo.
- Snapshot tables not yet created in this local PostgreSQL environment.
- Power BI not yet connected.
- Semantic model not yet validated.
- DAX measures not yet tested.
- Power BI vs SQL reconciliation not yet performed.
- User final validation not yet complete.

---

## 15. Next Phase Planning

### Phase 5 — Raw Layer Build

Planned tasks:

- [ ] Review `masked_source_profile_result.md`.
- [ ] Create raw DDL based on CSV headers.
- [ ] Create `raw.raw_bc_source`.
- [ ] Create `raw.raw_pic_list`.
- [ ] Create raw load approach.
- [ ] Load masked CSV into PostgreSQL raw tables.
- [ ] Validate raw row count.
- [ ] Validate raw column count.
- [ ] Validate no unexpected column loss.
- [ ] Commit raw DDL.
- [ ] Commit raw validation SQL.
- [ ] Update progress log.

### Phase 6 — Clean Layer Build

Planned tasks:

- [ ] Add raw-to-clean transform SQL.
- [ ] Standardize column names.
- [ ] Parse dates using MM/DD/YYYY.
- [ ] Cast amount fields.
- [ ] Normalize status fields.
- [ ] Convert invalid/missing PIC to UNCLASSIFIED where applicable.
- [ ] Validate raw vs clean row count.
- [ ] Validate key integrity.
- [ ] Validate duplicate BC risk.
- [ ] Validate date parsing.

### Phase 7 — Snapshot Layer Build

Planned tasks:

- [ ] Create snapshot tables.
- [ ] Add snapshot v1.1 fields.
- [ ] Add `is_open_unbilled`.
- [ ] Add `open_rab_exposure_amount`.
- [ ] Add `is_reported_excluded`.
- [ ] Add invoice completion fields.
- [ ] Add risk and manual review fields.
- [ ] Run snapshot function.
- [ ] Validate snapshot row count.
- [ ] Validate snapshot control fields.

### Phase 10+ — Power BI

Later tasks:

- Connect Power BI to PostgreSQL.
- Load:
  - `snapshot.bc_daily_status_snapshot`
  - `snapshot.vw_daily_movement_summary`
  - `clean.clean_pic_list`
- Build semantic model.
- Create DAX measures.
- Build pages:
  - Executive Overview
  - AR Controller
  - PIC Operation Scoring
  - Data Quality / Exception
- Reconcile Power BI vs approved SQL.

---

## 16. Handover Validation Result

Validation result:

```text
PASS
```

Risk level:

```text
LOW
```

Reason:

```text
Project purpose, repo structure, PostgreSQL foundation, GitHub link, completed phases, current hold point, next actions, and continuation rules are documented.
```