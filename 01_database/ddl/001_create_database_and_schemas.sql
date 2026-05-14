/*
===============================================================================
Finance_Ops_Dev - Database and Schema Setup
File: 01_database/ddl/001_create_database_and_schemas.sql

Purpose:
- Create project database
- Create controlled schemas for Finance Ops Dev
- Prepare PostgreSQL foundation for raw, clean, snapshot, mart, reporting,
  and documentation layers

Safety:
- This script is intended for local/development setup.
- Review before running in any shared or production PostgreSQL server.
===============================================================================
*/


-- =============================================================================
-- STEP 1: Create database
-- =============================================================================
-- Run this section while connected to the default postgres database.
-- If the database already exists, PostgreSQL will return an error.
-- That is acceptable during first setup review.

CREATE DATABASE finance_ops_dev;


-- =============================================================================
-- STEP 2: Connect to finance_ops_dev
-- =============================================================================
-- In psql, run:
-- \c finance_ops_dev
--
-- Then run the schema creation statements below.
-- =============================================================================


-- =============================================================================
-- STEP 3: Create schemas
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS clean;
CREATE SCHEMA IF NOT EXISTS snapshot;
CREATE SCHEMA IF NOT EXISTS mart;
CREATE SCHEMA IF NOT EXISTS reporting;
CREATE SCHEMA IF NOT EXISTS documentary;


-- =============================================================================
-- STEP 4: Add schema comments
-- =============================================================================

COMMENT ON SCHEMA raw IS
'Raw ingest layer. Stores source data with minimal transformation.';

COMMENT ON SCHEMA clean IS
'Clean layer. Stores standardized, typed, and validated data.';

COMMENT ON SCHEMA snapshot IS
'Snapshot layer. Stores daily BC status snapshot and issue history.';

COMMENT ON SCHEMA mart IS
'Mart layer. Stores subject-area analytical tables for reporting.';

COMMENT ON SCHEMA reporting IS
'Reporting layer. Stores Power BI-ready views and reporting outputs.';

COMMENT ON SCHEMA documentary IS
'Documentation and metadata layer. Stores data dictionary, validation logs, and lineage artifacts.';