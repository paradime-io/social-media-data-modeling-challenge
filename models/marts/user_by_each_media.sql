WITH authors_by_media AS (
    SELECT 
        media,
        author,
        COUNT(*) AS users_posts,
        COUNT(*) OVER() AS total_posts
    FROM {{ ref('int_all_posts') }}
    GROUP BY
        media,
        author
),
user_post_rate AS (
    SELECT 
        *,
        ( users_posts / total_posts) AS user_post_rate
    FROM authors_by_media
)
SELECT
    *
FROM user_post_rate
ORDER BY user_post_rate DESC
