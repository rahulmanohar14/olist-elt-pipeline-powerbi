WITH orders AS (
    -- Reference the raw orders table using dbt's source macro
    SELECT 
        order_id,
        customer_id,
        order_status,
        CAST(order_purchase_timestamp AS TIMESTAMP) AS purchase_timestamp
    FROM {{ source('raw_ecommerce', 'orders') }}
),

payments AS (
    -- Aggregate the payments so there is only one row per order
    SELECT
        order_id,
        SUM(payment_value) as total_revenue
    FROM {{ source('raw_ecommerce', 'order_payments') }}
    GROUP BY order_id
)

-- Join them together
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.purchase_timestamp,
    COALESCE(p.total_revenue, 0) AS total_revenue
FROM orders o
LEFT JOIN payments p 
    ON o.order_id = p.order_id