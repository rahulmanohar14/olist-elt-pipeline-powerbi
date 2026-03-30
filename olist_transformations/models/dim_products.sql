WITH products AS (
    SELECT 
        product_id,
        product_category_name,
        product_weight_g
    FROM {{ source('raw_ecommerce', 'products') }}
),

translations AS (
    SELECT 
        product_category_name,
        product_category_name_english
    FROM {{ source('raw_ecommerce', 'product_category_name_translation') }}
)

-- Join the tables to translate Portuguese categories to English
SELECT
    p.product_id,
    -- If there is no translation, keep the original name or label it 'Unknown'
    COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS product_category,
    p.product_weight_g
FROM products p
LEFT JOIN translations t 
    ON p.product_category_name = t.product_category_name