-- Indexes and execution plans.

CREATE INDEX IF NOT EXISTS idx_orders_customer_time
    ON orders (customer_id, order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_orders_purchase_time
    ON orders (order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
    ON order_items (order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
    ON order_items (product_id);

CREATE INDEX IF NOT EXISTS idx_reviews_order_id
    ON reviews (order_id);

CREATE INDEX IF NOT EXISTS idx_payments_order_id
    ON payments (order_id);

CREATE INDEX IF NOT EXISTS idx_products_category
    ON products (product_category_name);

EXPLAIN ANALYZE
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month_start,
    COUNT(*) AS order_cnt,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_purchase_timestamp >= DATE '2017-03-01'
GROUP BY 1
ORDER BY 1;

EXPLAIN ANALYZE
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_cnt,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_purchase_timestamp >= TIMESTAMP '2017-04-01'
GROUP BY c.customer_state
ORDER BY revenue DESC;

EXPLAIN ANALYZE
SELECT
    p.product_category_name,
    COUNT(*) AS item_cnt,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC;
