WITH reviews AS (
    SELECT
        review_id,
        order_id,
        CAST(review_score AS INT64) AS review_score,
        CAST(review_creation_date AS TIMESTAMP) AS review_date
    FROM {{ source('raw_ecommerce', 'order_reviews') }}
    WHERE review_score IS NOT NULL
),

order_products AS (
    SELECT
        oi.order_id,
        dp.product_category
    FROM {{ source('raw_ecommerce', 'order_items') }} oi
    LEFT JOIN {{ ref('dim_products') }} dp
        ON oi.product_id = dp.product_id
)

SELECT
    r.review_id,
    r.order_id,
    r.review_score,
    r.review_date,
    op.product_category
FROM reviews r
LEFT JOIN order_products op
    ON r.order_id = op.order_id