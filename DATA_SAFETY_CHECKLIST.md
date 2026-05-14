# Data Safety Checklist

## Purpose

This checklist must be reviewed before every commit to prevent sensitive Finance Ops project data from being uploaded to GitHub.

## Before Commit Checklist

- [ ] No `.env` file
- [ ] No real password
- [ ] No real database connection string
- [ ] No real API key
- [ ] No real CSV file
- [ ] No real Excel file
- [ ] No database dump
- [ ] No real Power BI PBIX with embedded data
- [ ] No real customer name
- [ ] No real PIC name if sensitive
- [ ] No real invoice number
- [ ] No confidential operational data
- [ ] No credential file
- [ ] No private key file
- [ ] No production export file
- [ ] Masked sample files are stored only under `03_sample_data_masked/`
- [ ] SQL files do not contain credentials
- [ ] Documentation does not expose sensitive business data

## Allowed Files

- [ ] SQL DDL scripts
- [ ] SQL transform scripts
- [ ] SQL validation scripts
- [ ] Approved SQL examples
- [ ] DAX measure files
- [ ] Markdown documentation
- [ ] Masked sample data
- [ ] Test cases
- [ ] Reconciliation checklist
- [ ] Semantic model documentation
- [ ] Dashboard mapping documentation

## Blocked Files

- [ ] Real operational data
- [ ] Real CSV / Excel source files
- [ ] Credentials
- [ ] Passwords
- [ ] Connection strings
- [ ] Database dumps
- [ ] PBIX files with embedded real data
- [ ] Raw production exports
- [ ] Private keys
- [ ] `.env` files

## Accepted Risk Notes

- Amount fields may remain unmasked only if the user confirms they are safe for the intended repository visibility.
- If the repository becomes public, amount fields must be reviewed again before publishing.
- PBIX files should remain outside the repository unless confirmed safe and free from embedded sensitive data.

## Required Command Before Commit

Run this command before every commit:

```bash
git status --untracked-files=all