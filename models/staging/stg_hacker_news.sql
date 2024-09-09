SELECT 
    id,
    title,
    url,
    by AS author,
    CAST(timestamp AS TIMESTAMP) AS creation_post_date,
    descendants AS comments
FROM {{ source('hn', 'hacker_news') }} 
WHERE type = 'story'