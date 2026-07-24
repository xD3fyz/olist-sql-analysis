-- RFM segmentation using the latest order date as the reference point.

WITH customer_metrics AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)::date AS last_purchase_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS monetary
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
),
base_scored AS (
    SELECT
        customer_unique_id,
        last_purchase_date,
        frequency,
        monetary,
        MAX(last_purchase_date) OVER () - last_purchase_date AS recency_days
    FROM customer_metrics
),
ranked AS (
    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary,
        (6 - NTILE(5) OVER (ORDER BY recency_days ASC)) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM base_scored
)
SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) AS rfm_code,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'loyal_customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'potential_new'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'at_risk_high_value'
        ELSE 'others'
    END AS segment
FROM ranked
ORDER BY r_score DESC, f_score DESC, m_score DESC;

WITH customer_metrics AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)::date AS last_purchase_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        ROUND(SUM(oi.price + oi.freight_value), 2) AS monetary
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id
), base_scored AS (
    SELECT
        customer_unique_id,
        frequency,
        monetary,
        MAX(last_purchase_date) OVER () - last_purchase_date AS recency_days
    FROM customer_metrics
), ranked AS (
    SELECT
        customer_unique_id,
        frequency,
        monetary,
        recency_days,
        (6 - NTILE(5) OVER (ORDER BY recency_days ASC)) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
    FROM base_scored
)
SELECT
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'loyal_customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'potential_new'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'at_risk_high_value'
        ELSE 'others'
    END AS segment,
    COUNT(*) AS customer_cnt,
    ROUND(AVG(monetary), 2) AS avg_monetary
FROM ranked
GROUP BY 1
ORDER BY customer_cnt DESC, avg_monetary DESC;
