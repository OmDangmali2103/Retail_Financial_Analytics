-- 1. PRODUCTS
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(255),
    -- NULL means this is a non-merchandise code with no merchandise unit cost.
    unit_cost NUMERIC(12, 2)
);

-- 2. ORDERS: one row per source transaction line.
CREATE TABLE orders (
    order_line_id BIGINT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    quantity INTEGER NOT NULL,
    order_date TIMESTAMP NOT NULL,
    unit_selling_price NUMERIC(12, 3) NOT NULL,
    customer_id INTEGER,
    region VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 3. INVOICES
CREATE TABLE invoices (
    invoice_id VARCHAR(50) PRIMARY KEY,
    customer_id INTEGER,
    invoice_date TIMESTAMP,
    due_date TIMESTAMP,
    invoice_amount NUMERIC(14, 3)
);

-- 4. PAYMENTS
CREATE TABLE payments (
    payment_id VARCHAR(50) PRIMARY KEY,
    invoice_id VARCHAR(50) NOT NULL,
    payment_date TIMESTAMP,
    payment_amount NUMERIC(14, 3),
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);

-- 5. INVENTORY SNAPSHOTS: one row per merchandise product and snapshot date.
CREATE TABLE inventory_snapshots (
    product_id VARCHAR(50) NOT NULL,
    snapshot_date DATE NOT NULL,
    stock_quantity INTEGER NOT NULL,
    PRIMARY KEY (product_id, snapshot_date),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
