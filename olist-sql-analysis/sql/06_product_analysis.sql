-- Product and category analysis, including basket analysis.

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_category_name,
        COUNT(*) AS sold_qty,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_category_name
)
SELECT
    product_id,
    product_category_name,
    sold_qty,
    revenue,
    RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM product_sales
ORDER BY revenue DESC;

WITH order_products AS (
    SELECT
        oi.order_id,
        oi.product_id,
        p.product_category_name
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
)
SELECT
    LEAST(a.product_category_name, b.product_category_name) AS category_1,
    GREATEST(a.product_category_name, b.product_category_name) AS category_2,
    COUNT(DISTINCT a.order_id) AS co_purchase_orders
FROM order_products a
JOIN order_products b
    ON a.order_id = b.order_id
   AND a.product_id < b.product_id
GROUP BY 1, 2
ORDER BY co_purchase_orders DESC, category_1, category_2;

WITH category_monthly AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month_start,
        p.product_category_name,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p ON p.product_id = oi.product_id
    GROUP BY 1, 2
)
SELECT
    month_start,
    product_category_name,
    revenue,
    RANK() OVER (PARTITION BY month_start ORDER BY revenue DESC) AS month_rank
FROM category_monthly
ORDER BY month_start, month_rank;
