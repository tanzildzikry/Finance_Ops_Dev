# Source File Register — Finance Ops Dev

## Purpose

This document records all source files used for the Finance_Ops_Dev development pipeline.

The goal is to control:

- Which files are allowed in the repository
- Which files are masked
- Which files map to PostgreSQL raw tables
- Which files are used for Power BI development
- Which files must stay outside GitHub

---

## Current Phase

Phase: Phase 4 — Source / Masked Data Preparation  
Status: IN PROGRESS  

---

## Data Safety Rule

Only masked or synthetic files may be stored in this repository.

Real operational files must stay outside this repository.

Approved repository folder for sample data:

```text
03_sample_data_masked/
```

Blocked from repository:

```text
Real CSV
Real Excel
Real customer name
Real PIC name if sensitive
Real invoice number
Credentials
Database dump
Power BI PBIX with embedded real data
Raw production export
```

---

## Source File Register

| File ID | File Name | Folder | Source Type | Masking Status | Target Raw Table | Target Clean Table | Status |
|---|---|---|---|---|---|---|---|
| SRC-001 | `masked_bc_source_sample.csv` | `03_sample_data_masked/` | CSV | MASKED / REVIEW REQUIRED | `raw.raw_bc_source` | `clean.clean_bc` | NOT ADDED |
| SRC-002 | `masked_pic_list_sample.csv` | `03_sample_data_masked/` | CSV | MASKED / REVIEW REQUIRED | `raw.raw_pic_list` | `clean.clean_pic_list` | NOT ADDED |

---

## Optional Future Source / Output Samples

| File ID | File Name | Folder | Source Type | Masking Status | Target Object | Status |
|---|---|---|---|---|---|---|
| OUT-001 | `masked_bc_daily_status_snapshot_sample.csv` | `03_sample_data_masked/` | CSV | MASKED / REVIEW REQUIRED | `snapshot.bc_daily_status_snapshot` | NOT STARTED |
| OUT-002 | `masked_daily_movement_summary_sample.csv` | `03_sample_data_masked/` | CSV | MASKED / REVIEW REQUIRED | `snapshot.vw_daily_movement_summary` | NOT STARTED |

---

## Required Files for Next Phase

Before entering Phase 5 — Raw Layer Build, these files must be available:

| Required File | Required? | Current Status |
|---|---:|---|
| `masked_bc_source_sample.csv` | Yes | NOT ADDED |
| `masked_pic_list_sample.csv` | Yes | NOT ADDED |

---

## Column Mapping Control

Column mapping must remain identical to the real project structure.

Required controls:

- Same business columns
- Same source column names where possible
- Same date format meaning
- Same status value meaning
- Same amount field meaning
- Same relationship key meaning
- Same PIC mapping logic
- Same BC key logic

Confirmed project source date format:

```text
MM/DD/YYYY
```

---

## Target Raw Table Naming

Initial target raw tables:

| Source File | Raw Table |
|---|---|
| `masked_bc_source_sample.csv` | `raw.raw_bc_source` |
| `masked_pic_list_sample.csv` | `raw.raw_pic_list` |

Control note:

Raw table names are initial working names and must be confirmed before Phase 5 DDL is finalized.

---

## Target Clean Table Naming

Initial target clean tables:

| Source File | Clean Table |
|---|---|
| `masked_bc_source_sample.csv` | `clean.clean_bc` |
| `masked_pic_list_sample.csv` | `clean.clean_pic_list` |

Control note:

Clean table names align with current Finance_Ops_Dev project knowledge and Power BI target objects.

---

## Masking Review Checklist

Before any source file is committed:

- [ ] File is stored only under `03_sample_data_masked/`
- [ ] File name starts with `masked_`
- [ ] No real customer name
- [ ] No real PIC name if sensitive
- [ ] No real invoice number
- [ ] No real credential
- [ ] No database connection string
- [ ] No database dump
- [ ] No raw production export
- [ ] No PBIX with embedded real data
- [ ] Column mapping is identical to real project
- [ ] Date format follows MM/DD/YYYY
- [ ] Amount fields are confirmed safe by user

---

## Accepted Risk Notes

Amount fields are currently accepted by the user as safe even if not masked.

Control note:

If the repository is later made public or shared externally, amount fields must be reviewed again before publication.

---

## Phase 4 Current Validation Result

Validation result:

```text
NEEDS REVIEW
```

Reason:

```text
Masked source files have not yet been added to the repository and reviewed.
```

Risk level:

```text
MEDIUM
```

---

## Next Action

Next step:

```text
Add masked source files to 03_sample_data_masked/
```

Required files:

```text
03_sample_data_masked/masked_bc_source_sample.csv
03_sample_data_masked/masked_pic_list_sample.csv
```

After files are added, run:

```bash
git status --untracked-files=all
```

Expected safe files:

```text
00_docs/source_file_register.md
03_sample_data_masked/masked_bc_source_sample.csv
03_sample_data_masked/masked_pic_list_sample.csv
```

Do not commit if any real source file appears.