-- Core business analysis: revenue, AOV, monthly trend, category ranking, and state comparison.

WITH order_revenue AS (
    SELECT
        oi.order_id,
        SUM(oi.price + oi.freight_value) AS revenue
    FROM order_items oi
    GROUP BY oi.order_id
)
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS active_customers,
    ROUND(SUM(orv.revenue), 2) AS total_revenue,
    ROUND(SUM(orv.revenue) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS avg_order_value
FROM orders o
JOIN order_revenue orv ON orv.order_id = o.order_id;

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month_start,
        COUNT(DISTINCT o.order_id) AS orders,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY 1
)
SELECT
    month_start,
    orders,
    revenue,
    ROUND(revenue - LAG(revenue) OVER (ORDER BY month_start), 2) AS mom_revenue_change,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month_start))
        / NULLIF(LAG(revenue) OVER (ORDER BY month_start), 0) * 100,
        2
    ) AS mom_revenue_growth_pct
FROM monthly_sales
ORDER BY month_start;

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS category_revenue,
    COUNT(*) AS item_cnt,
    RANK() OVER (ORDER BY SUM(oi.price + oi.freight_value) DESC) AS revenue_rank
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY category_revenue DESC;

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_cnt,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS revenue
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;
