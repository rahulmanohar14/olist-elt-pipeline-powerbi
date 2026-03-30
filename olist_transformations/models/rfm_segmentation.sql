WITH base_data AS (
    -- Step 1: Get the core metrics per customer
    SELECT
        customer_id,
        MAX(purchase_timestamp) AS last_purchase_date,
        COUNT(order_id) AS total_orders,
        SUM(total_revenue) AS total_spent
    FROM {{ ref('fact_orders') }}
    GROUP BY customer_id
),

recency_calc AS (
    -- Step 2: Calculate how many days ago their last purchase was
    -- Since Olist is a historical dataset, we measure against the most recent order in the database
    SELECT
        customer_id,
        total_orders,
        total_spent,
        TIMESTAMP_DIFF(
            (SELECT MAX(last_purchase_date) FROM base_data),
            last_purchase_date,
            DAY
        ) AS recency_days
    FROM base_data
)

-- Step 3: Segment the customers using business logic
SELECT
    customer_id,
    recency_days,
    total_orders,
    total_spent,
    CASE
        WHEN recency_days <= 30 AND total_orders > 1 THEN 'Champions'
        WHEN recency_days <= 60 AND total_orders = 1 THEN 'New Customers'
        WHEN recency_days > 180 AND total_orders > 1 THEN 'At Risk'
        WHEN recency_days > 180 AND total_orders = 1 THEN 'Lost Customers'
        ELSE 'Average Customers'
    END AS customer_segment
FROM recency_calc