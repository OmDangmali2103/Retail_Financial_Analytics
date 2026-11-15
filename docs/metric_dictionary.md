# Financial & Operations Analytics: Metric Dictionary

## 1. Reporting period
- **Source:** UCI Online Retail transaction data. Source unit prices are retained to three decimal places where present; generated invoice and payment amounts use the same precision.
- **Transaction period:** 1 December 2009 to 9 December 2011.
- **Simulated reporting date:** 10 December 2011.
- All as-of calculations include activity dated on or before 10 December 2011. In SQL this is implemented as a timestamp earlier than 11 December 2011.

## 2. Data provenance
- Orders and product descriptions originate from the public retail transaction dataset.
- **Unit costs, invoices, payments, and inventory quantities are synthetic.** They are generated for this project and are not historical company records.
- Synthetic data generation uses a fixed random seed (`42`) so rerunning the generation notebook reproduces the same outputs.
- Synthetic unit cost is 40%–70% of the median observed unit selling price for each merchandise product. This is an illustrative assumption, not a verified purchase/manufacturing cost.
- Known fees, adjustments, discounts, carriage, commissions, samples, and gift-voucher codes have no merchandise unit cost (`NULL`) and are excluded from merchandise gross-margin and inventory valuation calculations.
- Customer ID `999999` represents an unknown/unassigned customer. Its transactions remain included in company-level revenue, but it is shown separately from identified customers.

## 3. Revenue and profitability
- **Line revenue:** `quantity * unit_selling_price`.
- **Net sales revenue:** sum of line revenue, including negative-quantity return/cancellation lines retained in the orders table. Rows with non-positive unit selling price are excluded during source cleaning.
- **COGS:** `quantity * synthetic unit_cost`, for merchandise rows only. Negative-quantity returns reduce COGS under the same unit-cost assumption.
- **Gross profit:** merchandise net sales revenue minus merchandise COGS.
- **Gross margin percentage:** gross profit divided by merchandise net sales revenue, multiplied by 100; shown only when revenue is positive.
- Because unit costs are synthetic, gross profit and gross margin are scenario estimates, not actual company profitability.

## 4. Accounts receivable
- One order produces at most one positive invoice. C-prefixed credit/cancellation transactions are excluded from the invoice/payment simulation.
- **Outstanding balance as of reporting date:** invoice amount minus payments received on or before 10 December 2011, floored at zero for reporting.
- **Overdue:** a positive outstanding balance where 10 December 2011 is later than the contractual due date.
- Aging buckets: Current, 1–30, 31–60, 61–90, and 90+ days overdue.
- Invoice and payment records are synthetic; receivables findings are illustrative.

## 5. Inventory and working capital
- Inventory quantities are synthetic month-end snapshots generated for merchandise products only.
- For the 10 December 2011 as-of date, use the latest snapshot on or before that date (30 November 2011).
- **Stock exposure:** latest snapshot quantity multiplied by synthetic unit cost.
- Inventory turnover and DIO are not presented as validated operating metrics because both costs and stock quantities are synthetic and the stock series is not linked to replenishment or sales movements.

## 6. Grain and identifiers
- `orders`: one row per source transaction line; `order_line_id` is the unique line key.
- `products`: one row per trimmed product code.
- `invoices`: one row per generated invoice.
- `payments`: one generated payment record per paid invoice in this version.
- `inventory_snapshots`: one row per merchandise product and month-end snapshot date.
