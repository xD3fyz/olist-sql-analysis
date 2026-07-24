-- First order and repeat purchase analysis.

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS order_seq,
        COUNT(*) OVER (PARTITION BY c.customer_unique_id) AS customer_order_cnt
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
)
SELECT
    customer_unique_id,
    order_id,
    order_purchase_timestamp,
    order_seq,
    CASE WHEN order_seq = 1 THEN 'first_order' ELSE 'repeat_order' END AS order_type
FROM customer_orders
ORDER BY customer_unique_id, order_purchase_timestamp;

WITH monthly_customer_orders AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month_start,
        c.customer_unique_id,
        COUNT(*) AS order_cnt
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY 1, 2
),
repeat_customer_stats AS (
    SELECT
        month_start,
        COUNT(*) AS customers_with_orders,
        COUNT(*) FILTER (WHERE order_cnt >= 2) AS repeat_customers
    FROM monthly_customer_orders
    GROUP BY 1
)
SELECT
    month_start,
    customers_with_orders,
    repeat_customers,
    ROUND(repeat_customers::numeric / NULLIF(customers_with_orders, 0) * 100, 2) AS repeat_rate_pct
FROM repeat_customer_stats
ORDER BY month_start;

WITH first_orders AS (
    SELECT
        c.customer_unique_id,
        MIN(o.order_purchase_timestamp) AS first_order_time
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
customer_summary AS (
    SELECT
        c.customer_unique_id,
        COUNT(*) AS total_orders,
        SUM(oi.price + oi.freight_value) AS total_spend
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    f.customer_unique_id,
    f.first_order_time,
    cs.total_orders,
    ROUND(cs.total_spend, 2) AS total_spend,
    CASE
        WHEN cs.total_orders = 1 THEN 'one_time'
        WHEN cs.total_orders = 2 THEN 'repeat_2'
        ELSE 'loyal'
    END AS customer_type
FROM first_orders f
JOIN customer_summary cs ON cs.customer_unique_id = f.customer_unique_id
ORDER BY cs.total_orders DESC, cs.total_spend DESC;
