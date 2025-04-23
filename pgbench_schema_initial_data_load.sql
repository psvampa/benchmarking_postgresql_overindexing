-- Insert 20,000,000 products
-- sku and sku_number will be auto-generated using global_sku_seq
INSERT INTO products (name, description, price)
SELECT
    'Product ' || i,
    'Description for product ' || i,
    ROUND((RANDOM() * 1000 + 10)::NUMERIC, 2)
FROM generate_series(1, 20000000) AS i;

-- Insert 2,500 warehouses
INSERT INTO warehouses (name, location, max_capacity)
SELECT
    'Warehouse ' || i,
    'City ' || (i % 100 + 1),
    (RANDOM() * 5000 + 1000)::INT
FROM generate_series(1, 2500) AS i;

-- Insert 50 million stock records
-- We distribute 20M products evenly across 2,500 warehouses
INSERT INTO stock (
    product_id,
    warehouse_id,
    quantity,
    min_quantity,
    max_quantity,
    reorder_point,
    last_restock_date,
    is_active,
    location_code,
    batch_number,
    expiration_date,
    last_updated
)
SELECT
    ((s - 1) / 2500 + 1)::INT AS product_id,
    ((s - 1) % 2500 + 1)::INT AS warehouse_id,
    (RANDOM() * 500 + 1)::INT AS quantity,
    (RANDOM() * 10 + 1)::INT AS min_quantity,
    (RANDOM() * 100 + 50)::INT AS max_quantity,
    (RANDOM() * 20 + 5)::INT AS reorder_point,
    NOW() - (RANDOM() * INTERVAL '180 days') AS last_restock_date,
    TRUE,
    'LOC-' || FLOOR(RANDOM() * 10000)::INT AS location_code,
    'BATCH-' || FLOOR(RANDOM() * 100000)::INT AS batch_number,
    CURRENT_DATE + (RANDOM() * 365)::INT AS expiration_date,
    NOW() AS last_updated
FROM generate_series(1, 50000000) AS s;

-- Insert 1,000,000 stock movements
-- Each one references a valid product_id and warehouse_id
INSERT INTO stock_movements (
    product_id,
    warehouse_id,
    quantity,
    movement_type,
    movement_date,
    reason_code,
    reference_document,
    operator_name,
    approved_by,
    movement_status,
    created_at,
    updated_at
)
SELECT
    ((s - 1) / 2500 + 1)::INT AS product_id,
    ((s - 1) % 2500 + 1)::INT AS warehouse_id,
    (RANDOM() * 500 + 1)::INT AS quantity,
    CASE
        WHEN RANDOM() < 0.6 THEN 'inbound'
        WHEN RANDOM() < 0.9 THEN 'outbound'
        ELSE 'adjustment'
    END AS movement_type,
    NOW() - (RANDOM() * INTERVAL '365 days') AS movement_date,
    'RC-' || FLOOR(RANDOM() * 100)::INT AS reason_code,
    'DOC-' || FLOOR(RANDOM() * 100000)::INT AS reference_document,
    'Operator ' || FLOOR(RANDOM() * 500)::INT AS operator_name,
    'Supervisor ' || FLOOR(RANDOM() * 100)::INT AS approved_by,
    CASE
        WHEN RANDOM() < 0.8 THEN 'completed'
        ELSE 'pending'
    END AS movement_status,
    NOW(),
    NOW()
FROM generate_series(1, 1000000) AS s;
