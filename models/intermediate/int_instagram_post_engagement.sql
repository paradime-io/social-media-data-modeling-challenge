WITH source AS (
    SELECT 
        profile_id,
        username,
        num_likes,
        num_comments,
        num_following,
        num_followers,
        num_posts
    FROM {{ ref('stg_instagram') }}
)

SELECT 
    *,
    CASE
        WHEN num_likes + num_comments > 1000 THEN 'High'
        WHEN num_likes + num_comments BETWEEN 500 AND 1000 THEN 'Medium'
    ELSE 'Low'
    END AS engagement_level
FROM source