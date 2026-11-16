# Retail Financial & Operations Analytics

An end-to-end retail analytics project that combines Python-based data preparation, PostgreSQL data modeling, SQL business analysis, financial data validation, and Power BI reporting to evaluate retail financial performance and operational exposure.

The project transforms historical retail transaction data into an analytical database and an interactive dashboard covering profitability, customer contribution, receivables, inventory, and data quality.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Business Objectives](#business-objectives)
3. [Technology Stack](#technology-stack)
4. [Project Architecture](#project-architecture)
5. [Repository Structure](#repository-structure)
6. [Dataset and Data Sources](#dataset-and-data-sources)
7. [Data Preparation and Generation](#data-preparation-and-generation)
8. [Database Design](#database-design)
9. [Business Analysis](#business-analysis)
10. [Financial Data Validation](#financial-data-validation)
11. [Power BI Dashboard](#power-bi-dashboard)
12. [Illustrative Results](#illustrative-results)
13. [Business Assumptions and Limitations](#business-assumptions-and-limitations)
14. [Installation and Setup](#installation-and-setup)
15. [Execution Workflow](#execution-workflow)
16. [Reproducibility and Data Storage](#reproducibility-and-data-storage)
17. [Dataset Attribution](#dataset-attribution)

---

## 1. Project Overview

Retail businesses need reliable visibility into financial performance and operational activity. Transaction data alone does not provide a complete picture of profitability, outstanding receivables, inventory exposure, or data reliability.

This project develops an analytical workflow using historical retail transactions and additional synthetic financial and operational data.

The workflow covers:

- Preparing and transforming raw retail transaction data using Python.
- Generating synthetic product costs, invoices, payments, and inventory snapshots.
- Designing relational tables in PostgreSQL.
- Writing SQL queries to evaluate financial and operational performance.
- Validating financial records and identifying exceptions.
- Developing a Power BI dashboard for business reporting.

**Important:** The original retail transactions are sourced from a public dataset. Unit costs, invoices, payments, and inventory quantities are synthetically generated for analytical demonstration. Consequently, the financial results are illustrative and do not represent the actual financial statements of the retailer.

## 2. Business Objectives

The project addresses five broad business questions.

### Financial performance
- What is the merchandise revenue and cost of goods sold?
- What is the resulting gross profit and gross margin?
- Which products contribute most to merchandise profitability?

### Customer contribution
- How is merchandise revenue distributed across customers?
- How concentrated is revenue among the highest-contributing customers?
- How should unidentified customer transactions be treated in reporting?

### Receivables and collections
- How much simulated receivables exposure remains outstanding?
- How much of the outstanding balance is overdue?
- How is the outstanding balance distributed across aging categories?

### Inventory and operational exposure
- What is the latest available inventory position?
- What is the estimated inventory value?
- Which products have zero or low stock quantities?

### Financial data quality
- Are transaction lines uniquely identifiable?
- Are there selling prices below the assigned synthetic unit costs?
- Are non-merchandise transaction codes being incorrectly treated as products?
- Are payment records consistent with the corresponding invoice balances?

---

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| Python | Data preparation, transformation, and synthetic data generation |
| Pandas | Data manipulation and processing |
| NumPy | Numerical operations and synthetic data generation |
| Jupyter Notebook | Interactive data preparation and validation workflows |
| PostgreSQL | Relational database and analytical data storage |
| SQL | Schema creation, business logic, aggregations, and financial analysis |
| SQLAlchemy | Python-to-PostgreSQL database connectivity |
| Psycopg2 | PostgreSQL database adapter |
| Power BI | Interactive reporting and visualization |

---

## 4. Project Architecture

The project follows a sequential analytical workflow.

```text
UCI Online Retail II Dataset
            |
            v
    Raw Transaction Data
            |
            v
 Python Data Preparation
            |
            v
 Cleaned Orders and Synthetic Data
            |
            v
      CSV Data Outputs
            |
            v
     PostgreSQL Database
            |
       +----+----+
       |         |
       v         v
   SQL Analysis  Financial Validation
       |         |
       v         v
 Business       Exception Log
 Metrics
       |
       v
    Power BI
    Dashboard
```

### Workflow components

1. **Source data:** Historical retail transaction records from UCI.
2. **Data preparation:** Python processes transactions and generates additional illustrative datasets.
3. **Database layer:** PostgreSQL stores the relational tables.
4. **Analytical layer:** SQL implements financial and operational business logic.
5. **Validation layer:** Python checks loaded data and exports exception records.
6. **Reporting layer:** Power BI presents the analytical results.

---

## 5. Repository Structure

```text
Retail_Financial_Analytics/
│
├── dashboard/
│   └── Retail_Financial_Analytics_Dashboard.pbix
│
├── data/
│   └── Local datasets (not tracked by Git)
│
├── docs/
│   ├── exception_log.md
│   └── metric_dictionary.md
│
├── scripts/
│   ├── 01_data_generation.ipynb
│   └── 04_financial_validation.ipynb
│
├── sql/
│   ├── 02_schema_setup.sql
│   └── 03_business_logic.sql
│
├── .gitignore
├── README.md
└── requirements.txt
```

### Directory descriptions

| Directory/File | Description |
|---|---|
| `dashboard/` | Power BI report |
| `data/` | Source and generated CSV files stored locally |
| `docs/` | Metric definitions and exception-log documentation |
| `scripts/` | Python data-generation and validation notebooks |
| `sql/` | PostgreSQL schema and business-analysis queries |
| `requirements.txt` | Python dependencies |
| `.gitignore` | Excludes local datasets and unnecessary files from Git |

---

## 6. Dataset and Data Sources

### Primary source dataset

**UCI Online Retail II**

The project uses the Online Retail II dataset from the UCI Machine Learning Repository.

- Source: https://archive.ics.uci.edu/dataset/502/online+retail+ii
- Original creator: Daqing Chen
- Number of source transaction records: 1,067,371
- Coverage: 1 December 2009 – 9 December 2011
- Original format: Excel workbook containing two worksheets

The dataset includes:

| Column | Description |
|---|---|
| InvoiceNo | Transaction invoice identifier |
| StockCode | Product or transaction code |
| Description | Product description |
| Quantity | Transaction quantity |
| InvoiceDate | Transaction date and time |
| UnitPrice | Observed selling price per unit |
| CustomerID | Customer identifier |
| Country | Customer country |

The source data includes cancellations, missing customer identifiers, non-merchandise transaction codes, and other characteristics that require appropriate treatment during analysis.

### Local source-data preparation

The data-generation notebook expects:

`data/online_retail.csv`

Download the original UCI workbook and combine its two worksheets into a single CSV with consistent column names before running the notebook.

The resulting file must be saved at the path above.

The original dataset and generated CSV files are excluded from this GitHub repository. See [Reproducibility and Data Storage](#16-reproducibility-and-data-storage).

---

## 7. Data Preparation and Generation

**Notebook:** `scripts/01_data_generation.ipynb`

This notebook prepares the transaction data and generates the additional datasets required for financial and operational analysis.

### Main activities

- Read the source retail transaction data.
- Prepare and clean transaction records.
- Generate unique transaction-line identifiers.
- Identify merchandise and non-merchandise product codes.
- Generate synthetic unit costs.
- Generate illustrative invoice and payment records.
- Generate monthly inventory snapshots.
- Export the resulting datasets as CSV files.

### Generated datasets

| File | Purpose |
|---|---|
| `orders.csv` | Prepared retail transaction lines |
| `products.csv` | Product information and synthetic unit costs |
| `invoices.csv` | Synthetic invoice records |
| `payments.csv` | Synthetic payment records |
| `inventory.csv` | Generated inventory snapshots |

The notebook also uses a fixed random seed of `42` for its synthetic generation process.

This supports repeatability of the random generation process when the same inputs, code, and execution environment are used.

---

## 8. Database Design

**Schema:** `sql/02_schema_setup.sql`

**Database:** `retail_analytics`

PostgreSQL is used as the relational storage and analytical layer.

The database contains the following principal tables:

| Table | Description |
|---|---|
| `orders` | Prepared retail transaction lines |
| `products` | Product details and synthetic unit costs |
| `invoices` | Simulated invoice records |
| `payments` | Simulated payment records |
| `inventory_snapshots` | Product-level inventory quantities across snapshot dates |

### Key data-model considerations

- `order_line_id` uniquely identifies each transaction line.
- Product records provide the synthetic cost information used in margin analysis.
- Invoice and payment records support simulated receivables analysis.
- Inventory uses product and snapshot date to identify inventory positions over time.
- Product identifiers connect merchandise transactions with product information.

The schema is designed to support the business queries and validation workflow included in this project.

---

## 9. Business Analysis

**SQL file:** `sql/03_business_logic.sql`

The SQL business logic covers financial performance, customer contribution, receivables, and inventory exposure.

### 9.1 Product profitability

Evaluates merchandise revenue, synthetic cost of goods sold, gross profit, and gross margin.

Core measures:

- Merchandise revenue
- Cost of goods sold (COGS)
- Gross profit
- Gross margin percentage

\[
\text{Gross Profit} = \text{Revenue} - \text{COGS}
\]

\[
\text{Gross Margin \%} =
\frac{\text{Gross Profit}}{\text{Revenue}}\times100
\]

### 9.2 Customer contribution

Examines customer-level merchandise revenue and the distribution of revenue across customers.

The analysis supports customer contribution and revenue concentration reporting.

Customer ID `999999` represents the unknown or unassigned customer bucket. Its revenue is retained in company-level totals but should not be interpreted as revenue from an identified individual customer.

### 9.3 Receivables aging

Evaluates simulated outstanding invoice balances as of the reporting date.

The analysis classifies outstanding balances into aging categories:

- Current
- 1–30 days overdue
- 31–60 days overdue
- 61–90 days overdue
- More than 90 days overdue

Receivables calculations use the reporting date of **10 December 2011** and account for payments received by that date.

### 9.4 Inventory exposure

Uses the latest eligible inventory snapshot on or before the reporting date.

The analysis evaluates:

- Total stock quantity
- Zero-stock products
- Estimated inventory value
- Product-level inventory exposure

The latest eligible snapshot in the current scenario is **30 November 2011**.

---

## 10. Financial Data Validation

**Notebook:** `scripts/04_financial_validation.ipynb`

The validation notebook checks the PostgreSQL tables and produces an exception log for identified data-quality issues.

### Validation focus

- Transaction-line identifier uniqueness
- Product reference consistency
- Merchandise and non-merchandise classification
- Selling-price versus synthetic-cost checks
- Payment and invoice consistency
- Duplicate exception-record checks

### Exception log

Generated output:

`data/financial_exception_log.csv`

The exception log records identified validation issues and includes fields such as:

- `record_id`
- `rule_failed`
- `observed_value`
- `reason`
- `resolution_status`

Each exception represents a record requiring review under the defined validation rules. An exception is not automatically proof of an incorrect business transaction.

Additional documentation is available in:

`docs/exception_log.md`

---

## 11. Power BI Dashboard

**Report:** `dashboard/Retail_Financial_Analytics_Dashboard.pbix`

The Power BI report presents the financial and operational analysis through four reporting areas.

### Page 1 – Executive Financial Overview

Provides a high-level view of the financial performance of the illustrative retail scenario.

Focus areas:
- Revenue
- Cost of goods sold
- Gross profit
- Gross margin
- Key financial performance indicators

### Page 2 – Receivables and Collections

Focuses on simulated outstanding receivables and collection exposure.

Focus areas:
- Outstanding receivables
- Overdue balances
- Receivables aging
- Collection-related analysis

### Page 3 – Product and Customer Profitability

Examines the contribution of products and customers to merchandise performance.

Focus areas:
- Product-level profitability
- Customer contribution
- Revenue concentration
- Gross margin analysis

### Page 4 – Inventory and Operational Risk

Provides visibility into the simulated inventory position and operational exceptions.

Focus areas:
- Inventory value
- Stock quantities
- Zero-stock products
- Financial validation exceptions

**To explore the dashboard:** Download the PBIX file and open it using Microsoft Power BI Desktop.

---

## 12. Illustrative Results

The following figures describe the current generated project scenario. They are not actual financial results from the retailer.

### Generated data checks

| Measure | Current result |
|---|---:|
| Prepared order lines | 1,061,164 |
| Unique order-line identifiers | 1,061,164 |
| Unique products | 4,931 |
| Merchandise products | 4,911 |
| Non-merchandise codes | 20 |
| Invoice records | 40,077 |
| Payment records | 36,063 |
| Financial exception records | 24,595 |

The current generated files were checked for unique order-line identifiers, duplicate exception pairs, orphan payments, and overpayments.

### Illustrative financial outputs

| Metric | Current scenario |
|---|---:|
| Merchandise COGS | 11.19M |
| Gross profit | 8.20M |
| Gross margin | 42.29% |
| Outstanding receivables | 4.31M |
| Overdue receivables | 3.15M |
| Estimated inventory value | 2.71M |

All monetary amounts use the source dataset's currency convention without foreign-exchange conversion.

The figures depend on the synthetic cost, invoice, payment, and inventory generation assumptions. Regenerating the datasets may change the results if the generation logic, source data, or execution environment changes.

---

## 13. Business Assumptions and Limitations

Understanding the assumptions is essential when interpreting the dashboard and analytical results.

### Synthetic financial and operational data

The following information is generated for demonstration:

- Unit costs
- Invoice records
- Payment records
- Inventory quantities

These are not actual records from the retailer.

### Synthetic unit costs

Unit costs are generated using approximately 40%–70% of each merchandise product's median observed selling price.

This is an illustrative cost-generation approach, not a verified supplier-cost or accounting-cost methodology.

### Non-merchandise transaction codes

Fee, adjustment, discount, carriage, commission, sample, and gift-voucher codes do not receive merchandise costs and are excluded from merchandise margin and inventory valuation calculations.

### Reporting date

The financial reporting date is **10 December 2011**.

Receivables include payments received by that date. Inventory valuation uses the latest available snapshot on or before that date, which is **30 November 2011**.

### Unknown customer identification

Customer ID `999999` is treated as an unknown or unassigned customer category.

It remains part of company-level revenue calculations but should not be treated as an identified customer.

### Interpretation limitations

- Gross profit and gross margin depend on synthetic cost assumptions.
- Receivables and collection metrics are based on simulated invoices and payments.
- Inventory values and stock quantities are illustrative.
- Historical transaction patterns do not establish actual retailer profitability.
- Validation exceptions indicate records requiring investigation, not necessarily confirmed financial misstatements.
- The project is an independent portfolio exercise and is not commissioned by or affiliated with the original retailer.

---

## 14. Installation and Setup

### Prerequisites

Install the following software:

- Python
- PostgreSQL
- pgAdmin or another PostgreSQL client
- Jupyter Notebook
- Microsoft Power BI Desktop

### Clone the repository

```bash
git clone https://github.com/OmDangmali2103/Retail_Financial_Analytics.git
```

Navigate into the project directory:

```bash
cd Retail_Financial_Analytics
```

### Create a virtual environment

```bash
python -m venv .venv
```

Activate it on Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### Install dependencies

```bash
pip install -r requirements.txt
```

Dependencies:

- pandas
- numpy
- SQLAlchemy
- psycopg2-binary
- jupyter

### Prepare the source dataset

Download the UCI Online Retail II workbook.

Prepare a single CSV from both worksheets and save it as:

```text
data/online_retail.csv
```

Create the local `data/` directory if it does not already exist.

### Create the PostgreSQL database

Create an empty PostgreSQL database named:

```text
retail_analytics
```

The schema script creates the project tables; it does not create the database itself.

---

## 15. Execution Workflow

Run the project components in the following order.

### Step 1 – Generate and prepare datasets

Open:

```text
scripts/01_data_generation.ipynb
```

Run the notebook cells to process the source transactions and generate the required CSV files in `data/`.

### Step 2 – Create the PostgreSQL schema

Execute:

```text
sql/02_schema_setup.sql
```

Run the script against the `retail_analytics` database.

The updated `orders` table includes `order_line_id`. If an older version of the table exists without this column, back up any required data and recreate that table before importing the updated CSV.

The schema script does not automatically delete existing data.

### Step 3 – Import the generated CSV files

Import the files into PostgreSQL in this order:

| Import order | CSV file | Destination table |
|---:|---|---|
| 1 | `products.csv` | `products` |
| 2 | `orders.csv` | `orders` |
| 3 | `invoices.csv` | `invoices` |
| 4 | `payments.csv` | `payments` |
| 5 | `inventory.csv` | `inventory_snapshots` |

Preserve the CSV column names during import.

Import blank `unit_cost` values as SQL `NULL`.

### Step 4 – Execute business analysis

Run:

```text
sql/03_business_logic.sql
```

Execute the queries against the populated PostgreSQL database.

### Step 5 – Perform financial validation

Open:

```text
scripts/04_financial_validation.ipynb
```

Run the notebook to validate the loaded tables and generate the financial exception log.

### Step 6 – Explore the dashboard

Open:

```text
dashboard/Retail_Financial_Analytics_Dashboard.pbix
```

using Microsoft Power BI Desktop.

Ensure the Power BI report is connected to the corresponding PostgreSQL database and that its data is refreshed after the required tables have been populated.

**Important:** Back up existing database tables before replacing them. The schema script creates table definitions; it does not automatically remove existing records.

---

## 16. Reproducibility and Data Storage

The repository intentionally excludes raw and generated CSV files.

The following files are stored locally and are not committed to Git:

- `online_retail.csv`
- `orders.csv`
- `products.csv`
- `invoices.csv`
- `payments.csv`
- `inventory.csv`
- `financial_exception_log.csv`

This keeps the GitHub repository focused on source code, SQL logic, documentation, and the Power BI deliverable rather than large data files.

To reproduce the workflow:

1. Obtain the original UCI dataset.
2. Prepare the expected input CSV.
3. Run the data-generation notebook.
4. Create the PostgreSQL schema.
5. Import the generated datasets.
6. Execute the SQL business logic.
7. Run the validation notebook.
8. Refresh the Power BI report.

The random seed is fixed at `42` in the generation notebook. Reproducibility also depends on using the same source data and compatible software environment.

---

## 17. Dataset Attribution

This project uses the following publicly available dataset:

**Chen, D. (2012). Online Retail II [Dataset]. UCI Machine Learning Repository.**

Dataset DOI:

https://doi.org/10.24432/C5CG6D

Dataset source:

https://archive.ics.uci.edu/dataset/502/online+retail+ii

The dataset is licensed under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.

The original dataset is attributed to its creator and source. The synthetic financial and operational data used in this project are independently generated for analytical demonstration.

---

## Project Disclaimer

This is an independent portfolio project developed for demonstrating practical skills in data engineering, database management, financial analysis, data validation, SQL, and business intelligence.

It does not represent the actual financial statements, accounting records, or operational performance of the original retailer.
