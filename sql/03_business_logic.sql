-- Reporting date used consistently in the project.
-- Data extends through 2011-12-09; 2011-12-10 is the simulated as-of date.

-- 1. Product gross margin.
-- Costs are synthetic estimates; only merchandise rows have a unit_cost.
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity * o.unit_selling_price) AS net_sales,
    SUM(o.quantity * p.unit_cost) AS cogs,
    SUM(o.quantity * o.unit_selling_price)
        - SUM(o.quantity * p.unit_cost) AS gross_profit,
    ROUND(
        (
            SUM(o.quantity * o.unit_selling_price)
            - SUM(o.quantity * p.unit_cost)
        ) / NULLIF(SUM(o.quantity * o.unit_selling_price), 0) * 100,
        2
    ) AS gross_margin_pct
FROM orders o
JOIN products p ON p.product_id = o.product_id
WHERE p.unit_cost IS NOT NULL
  AND o.order_date < TIMESTAMP '2011-12-11 00:00:00'
GROUP BY p.product_id, p.product_name
HAVING SUM(o.quantity * o.unit_selling_price) > 0
ORDER BY gross_margin_pct DESC;


-- 2. Customer revenue contribution.
-- Customer 999999 is the explicit unknown/unassigned customer bucket.
-- Its revenue remains in the company total but is not a real customer.
WITH customer_revenue AS (
    SELECT
        customer_id,
        SUM(quantity * unit_selling_price) AS customer_net_sales
    FROM orders
    WHERE order_date < TIMESTAMP '2011-12-11 00:00:00'
    GROUP BY customer_id
)
SELECT
    customer_id,
    CASE
        WHEN customer_id = 999999 THEN 'Unknown / Unassigned'
        ELSE 'Identified Customer'
    END AS customer_group,
    customer_net_sales,
    SUM(customer_net_sales) OVER () AS total_company_sales,
    ROUND(
        customer_net_sales / NULLIF(SUM(customer_net_sales) OVER (), 0) * 100,
        2
    ) AS revenue_concentration_pct
FROM customer_revenue
ORDER BY revenue_concentration_pct DESC;


-- 3. Receivables aging as of 10 December 2011.
-- Only payments received on or before the reporting date reduce receivables.
WITH payment_summary AS (
    SELECT
        invoice_id,
        SUM(payment_amount) AS total_payments
    FROM payments
    WHERE payment_date < TIMESTAMP '2011-12-11 00:00:00'
    GROUP BY invoice_id
),
invoice_aging AS (
    SELECT
        i.invoice_id,
        i.customer_id,
        i.invoice_amount,
        COALESCE(ps.total_payments, 0) AS total_payments,
        i.invoice_amount - COALESCE(ps.total_payments, 0) AS outstanding_balance,
        DATE '2011-12-10' - i.due_date::date AS days_overdue
    FROM invoices i
    LEFT JOIN payment_summary ps ON ps.invoice_id = i.invoice_id
    WHERE i.invoice_date < TIMESTAMP '2011-12-11 00:00:00'
      AND i.invoice_amount - COALESCE(ps.total_payments, 0) > 0
),
aging_categories AS (
    SELECT
        invoice_id,
        customer_id,
        outstanding_balance,
        days_overdue,
        CASE
            WHEN days_overdue <= 0 THEN 'Current'
            WHEN days_overdue BETWEEN 1 AND 30 THEN '1-30 Days Overdue'
            WHEN days_overdue BETWEEN 31 AND 60 THEN '31-60 Days Overdue'
            WHEN days_overdue BETWEEN 61 AND 90 THEN '61-90 Days Overdue'
            ELSE '90+ Days Overdue'
        END AS aging_bucket
    FROM invoice_aging
)
SELECT
    aging_bucket,
    COUNT(invoice_id) AS invoice_count,
    ROUND(SUM(outstanding_balance), 2) AS total_outstanding_amount
FROM aging_categories
GROUP BY aging_bucket
ORDER BY CASE aging_bucket
    WHEN 'Current' THEN 1
    WHEN '1-30 Days Overdue' THEN 2
    WHEN '31-60 Days Overdue' THEN 3
    WHEN '61-90 Days Overdue' THEN 4
    WHEN '90+ Days Overdue' THEN 5
END;


-- 4. Inventory exposure / slow-sales screening as of 10 December 2011.
-- The latest available snapshot before that date is 30 November 2011.
-- This is an illustrative screen because stock quantities are synthetic.
WITH latest_inventory AS (
    SELECT DISTINCT ON (product_id)
        product_id,
        snapshot_date,
        stock_quantity
    FROM inventory_snapshots
    WHERE snapshot_date <= DATE '2011-12-10'
    ORDER BY product_id, snapshot_date DESC
),
total_sales AS (
    SELECT
        product_id,
        SUM(quantity) AS total_units_sold,
        SUM(quantity * unit_selling_price) AS total_net_sales
    FROM orders
    WHERE order_date < TIMESTAMP '2011-12-11 00:00:00'
    GROUP BY product_id
)
SELECT
    p.product_id,
    p.product_name,
    li.snapshot_date AS inventory_snapshot_date,
    p.unit_cost AS simulated_unit_cost,
    li.stock_quantity,
    COALESCE(s.total_units_sold, 0) AS total_units_sold,
    COALESCE(s.total_net_sales, 0.00) AS total_net_sales,
    ROUND(li.stock_quantity * p.unit_cost, 2) AS stock_exposure_value
FROM products p
JOIN latest_inventory li ON li.product_id = p.product_id
LEFT JOIN total_sales s ON s.product_id = p.product_id
WHERE p.unit_cost IS NOT NULL
  AND li.stock_quantity > 200
  AND COALESCE(s.total_units_sold, 0) < 50
ORDER BY stock_exposure_value DESC;
