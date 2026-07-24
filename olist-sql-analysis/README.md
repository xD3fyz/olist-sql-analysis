# SQL Portfolio Project

This project is a PostgreSQL-based e-commerce analytics sandbox. It is designed to prove practical SQL skill across schema design, data loading, analytical queries, window functions, customer retention, RFM segmentation, product basket analysis, delivery quality, and query optimization.

## What is included

- `sql/01_schema.sql`: tables, keys, and constraints
- `sql/02_seed_data.sql`: realistic demo data
- `sql/03_basic_analysis.sql`: revenue, AOV, monthly trends, category ranking
- `sql/04_customer_repurchase.sql`: first order and repeat purchase analysis
- `sql/05_rfm_segmentation.sql`: RFM customer segmentation
- `sql/06_product_analysis.sql`: product, category, and basket analysis
- `sql/07_delivery_review_analysis.sql`: delivery delay vs review score
- `sql/08_optimization.sql`: indexes and `EXPLAIN ANALYZE`
- `scripts/01_init_local_pg.ps1`: initialize a local PostgreSQL data directory
- `scripts/02_start_local_pg.ps1`: start the local PostgreSQL server
- `scripts/03_run_all.ps1`: create the demo DB and run all SQL files with `psql`
- `data_dictionary.md`: table and column definitions

## Prerequisites

This repo ships with PostgreSQL client and server binaries already downloaded under:

`C:\Users\HaleD\.codex\tools\postgresql-client\pgsql\bin`

You only need Windows PowerShell and the bundled binaries in that folder.

## Recommended workflow

1. Run `scripts/01_init_local_pg.ps1`
2. Run `scripts/02_start_local_pg.ps1`
3. Run `scripts/03_run_all.ps1`
4. Inspect the outputs in `psql`
5. Stop the server with `pg_ctl stop` when done

## Why this project is strong for SQL practice

It covers the main patterns interviewers expect:

- multi-table joins
- CTEs
- `CASE WHEN`
- date arithmetic
- `ROW_NUMBER`, `RANK`, `LAG`, `NTILE`
- repeat-purchase logic
- customer segmentation
- basket analysis
- operational analytics
- index design and execution plans

## Resume-ready summary

> Built a PostgreSQL e-commerce analytics project with a normalized order model, demo dataset, and analysis suite covering revenue trends, repeat purchase, RFM segmentation, product basket analysis, delivery delay impact, and query optimization using indexes and `EXPLAIN ANALYZE`.

## How to ask for explanations later

Send any SQL file or query here and I will explain it line by line in Chinese.
