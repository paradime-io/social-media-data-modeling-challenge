WITH source AS (
    SELECT 
        sid,
        profile_id,
        num_likes,
        num_comments
    FROM {{ ref('stg_instagram') }}
)

SELECT 
    *,
    CASE
        WHEN num_likes + num_comments > 1000 THEN 'High'
        WHEN num_likes + num_comments BETWEEN 500 AND 1000 THEN 'Medium'
    ELSE 'Low'
    END AS engagement_level,
    num_likes + num_comments AS total_engagement
FROM source