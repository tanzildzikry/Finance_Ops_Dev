# Finance Ops Dev

## Project Purpose

This repository stores controlled development artifacts for the Finance_Ops_Dev project.

The project focuses on:

- PostgreSQL database layer
- SQL transform and validation
- Snapshot logic
- Power BI semantic model documentation
- DAX measure library
- Dashboard mapping
- KPI reconciliation
- Data quality control

## Current Dashboard Scope

Current focus:

- Unbilled Monitoring
- Executive Overview
- AR Controller
- PIC Operation Scoring
- Daily Snapshot
- Data Quality / Exception Control

Out of scope for now:

- Actual cashflow
- Actual cash-in
- DSO
- Collection performance
- Payment overdue final

## Data Safety Policy

This repository is for development using masked or synthetic data only.

Not allowed in this repository:

- Real customer data
- Real PIC data if sensitive
- Real invoice numbers
- Real transaction files
- Real CSV / Excel exports
- Database dumps
- Power BI PBIX files with embedded real data
- Credentials
- Passwords
- `.env`
- Connection strings
- API keys

Allowed in this repository:

- Masked sample data
- SQL DDL
- SQL transform scripts
- SQL validation scripts
- Approved SQL examples
- DAX measures
- Power BI documentation
- Semantic model documentation
- Dashboard page mapping
- Test cases
- Reconciliation checklist

## Data Policy

The folder `03_sample_data_masked/` is the only approved location for masked sample files.

Real project data must stay outside this repository and must be stored only in PostgreSQL or a secure local folder.

## Validation Status

Current setup status:

- `.gitignore`: PASS
- `.env.example`: PASS
- Masked sample folder: PASS
- Real data separation: PASS

## Production Readiness

This repository is not yet production-ready.

Production readiness requires:

- PostgreSQL validation PASS
- Snapshot validation PASS
- Power BI semantic model validation PASS
- DAX validation PASS
- Power BI vs SQL reconciliation PASS
- User final validation PASS