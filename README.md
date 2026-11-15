# Retail Financial & Operations Analytics

## Project contents

- `data/`: source retail transactions and generated project tables.
- `scripts/01_data_generation.ipynb`: creates the cleaned orders, synthetic costs, invoices, payments, and inventory snapshots.
- `scripts/04_financial_validation.ipynb`: checks the loaded PostgreSQL tables and exports the exception log.
- `sql/02_schema_setup.sql`: current PostgreSQL table definitions.
- `sql/03_business_logic.sql`: product margin, customer contribution, receivables aging, and inventory exposure queries.
- `docs/`: metric definitions and exception-log notes.

## Run order

Install the Python dependencies once with `pip install -r requirements.txt`.

1. Open `scripts/01_data_generation.ipynb` and run all cells. It reads `data/online_retail.csv` and writes the regenerated CSVs to `data/`. The fixed random seed is `42`.
2. Create or refresh the PostgreSQL tables using `sql/02_schema_setup.sql`. The updated `orders` table includes `order_line_id`; the old `orders` table must be recreated before importing the new CSV.
3. Import the CSVs in this order: `products.csv` → `products`, `orders.csv` → `orders`, `invoices.csv` → `invoices`, `payments.csv` → `payments`, `inventory.csv` → `inventory_snapshots`. Preserve the CSV column names and import blank `unit_cost` values as SQL `NULL`.
4. Run `sql/03_business_logic.sql` and then `scripts/04_financial_validation.ipynb`.

Back up any existing database tables before replacing them. The schema script creates tables; it does not delete existing data.

## Important interpretation

The retail transaction rows come from the public Online Retail dataset. **Unit costs, invoices, payments, and inventory quantities are synthetic and illustrative**, not actual company records. Unit costs use 40%–70% of each merchandise product's median observed selling price to limit the effect of one-off price spikes. Fee, adjustment, discount, carriage, commission, sample, and gift-voucher codes have no merchandise cost and are excluded from product margin and inventory valuation.

The reporting date is 10 December 2011. Receivables include only payments received by that date. Inventory uses the latest available snapshot on or before that date (30 November 2011).

Customer ID `999999` is the unknown/unassigned customer bucket. Its revenue remains in company totals but should not be described as an identified customer. `order_line_id` uniquely identifies each transaction line and is the reference used by the below-cost exception rule.

## Dashboard

## Dashboard

The Power BI report is available in:

`dashboard/Retail_Financial_Analytics_Dashboard.pbix`

Open the file using Microsoft Power BI Desktop to explore the financial and operational analytics report.


## Regenerated data checks

The corrected files were checked locally:

- 1,061,164 order lines with unique `order_line_id` values.
- 4,931 unique products, including 4,911 merchandise products and 20 non-merchandise codes with `NULL` cost.
- 40,077 invoices and 36,063 payments; no orphan payments or overpayments.
- 24,595 exception rows with no duplicate `(record_id, rule_failed)` pairs.

The current synthetic scenario produces 11.19M in merchandise COGS, 8.20M in gross profit, and 42.29% gross margin. As of 10 December 2011, simulated outstanding receivables are 4.31M, of which 3.15M is overdue. The latest eligible inventory snapshot is 30 November 2011; its simulated stock value is 2.71M. Monetary amounts use the source data currency units without FX conversion. These values are illustrative because the related cost, invoice, payment, and inventory inputs are synthetic.
