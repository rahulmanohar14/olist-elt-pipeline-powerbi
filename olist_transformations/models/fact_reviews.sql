SELECT 
    review_id,
    order_id,
    CAST(review_score AS INT64) AS review_score,
    CAST(review_creation_date AS TIMESTAMP) AS review_date
FROM `olist-analytics-491319.raw_data.order_reviews`
WHERE review_score IS NOT NULL