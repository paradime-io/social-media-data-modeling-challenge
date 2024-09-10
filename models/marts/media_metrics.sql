SELECT 
    media,
    COUNT(*) AS total_posts,
    COUNT(DISTINCT author) AS different_authors,
    SUM(CAST(comments AS NUMERIC)) AS all_comments,
    ( SUM(CAST(comments AS NUMERIC)) // total_posts ) comments_by_posts
FROM {{ ref('int_all_posts') }}
WHERE title IS NOT NULL
GROUP BY 
    media