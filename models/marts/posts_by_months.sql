SELECT 
    media,
    CAST(creation_post_date AS DATE),
    COUNT(*)
FROM {{ ref('int_all_posts') }}
WHERE title IS NOT NULL
GROUP BY 
    media,
    CAST(creation_post_date AS DATE)