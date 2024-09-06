SELECT 
    id,
    title,
    url,
    by AS author,
    timestamp AS creation_post_date,
    time AS creation_post_unix,
    score,
    descendants AS comments
FROM {{ source('hn', 'hacker_news') }} 
WHERE type = 'story'