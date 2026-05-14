# Repository Scope

## Project

Finance_Ops_Dev

## Repository Purpose

This repository stores controlled development artifacts for the Finance_Ops_Dev project.

The repository is used for:

- PostgreSQL database structure
- SQL transform scripts
- SQL validation scripts
- Snapshot logic
- Approved SQL examples
- DAX measure library
- Power BI semantic model documentation
- Dashboard page mapping
- KPI reconciliation checklist
- Data quality checklist
- Masked sample data

## Data Policy

This repository uses masked or synthetic data only.

Real operational data must not be stored in this repository.

Real project data must stay outside this repository and must be stored only in:

- PostgreSQL database
- Secure local folder
- Approved secure internal storage

## In Scope

The following artifacts are allowed in this repository:

- PostgreSQL DDL scripts
- Raw to clean transform SQL
- Snapshot SQL
- Validation SQL
- Approved SQL examples
- DAX measure files
- Power BI semantic model documentation
- Dashboard page mapping
- KPI definition documentation
- Reconciliation checklist
- Data quality checklist
- Test cases
- Masked sample data
- Synthetic sample data
- Project documentation

## Out of Scope

The following artifacts are not allowed in this repository:

- Real operational CSV files
- Real operational Excel files
- Real customer data
- Real PIC data if sensitive
- Real invoice data
- Real confidential transaction amount
- Database dumps
- PostgreSQL backup files
- Power BI PBIX files with embedded real data
- Credentials
- Passwords
- `.env` files
- API keys
- Private keys
- Connection strings
- Gateway credentials
- Raw production exports

## Approved Data Folder

The only approved folder for sample data is:

```text
03_sample_data_masked/