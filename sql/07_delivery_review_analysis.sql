-- Delivery delay and review score analysis.

WITH delivered_orders AS (
    SELECT
        o.order_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date::date AS delivered_date,
        o.order_estimated_delivery_date,
        (o.order_delivered_customer_date::date - o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    CASE
        WHEN delay_days <= 0 THEN 'on_time_or_early'
        WHEN delay_days BETWEEN 1 AND 3 THEN 'late_1_3_days'
        WHEN delay_days BETWEEN 4 AND 7 THEN 'late_4_7_days'
        ELSE 'late_8_plus_days'
    END AS delay_bucket,
    COUNT(*) AS orders_cnt,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(AVG(delay_days), 2) AS avg_delay_days
FROM delivered_orders d
JOIN reviews r ON r.order_id = d.order_id
GROUP BY 1
ORDER BY orders_cnt DESC;

WITH order_delay AS (
    SELECT
        o.order_id,
        (o.order_delivered_customer_date::date - o.order_estimated_delivery_date) AS delay_days
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    r.review_score,
    COUNT(*) AS order_cnt,
    ROUND(AVG(od.delay_days), 2) AS avg_delay_days,
    ROUND(AVG(CASE WHEN od.delay_days > 0 THEN 1 ELSE 0 END) * 100, 2) AS late_delivery_rate_pct
FROM reviews r
JOIN order_delay od ON od.order_id = r.order_id
GROUP BY r.review_score
ORDER BY r.review_score DESC;

SELECT
    payment_type,
    COUNT(*) AS payment_orders,
    ROUND(AVG(payment_installments), 2) AS avg_installments,
    ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM payments
GROUP BY payment_type
ORDER BY payment_orders DESC, avg_payment_value DESC;
