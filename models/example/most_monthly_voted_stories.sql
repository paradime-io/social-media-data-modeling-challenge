WITH hacker_news AS (
    SELECT
    *
    FROM {{ source('hn', 'hacker_news') }}
)
,
ranked_stories AS (
    SELECT
        title,
        'https://news.ycombinator.com/item?id=' || id AS hn_url,
        score,
        YEAR(timestamp) AS year,
        MONTH(timestamp) AS month,
        ROW_NUMBER()
            OVER (PARTITION BY YEAR(timestamp), MONTH(timestamp) ORDER BY score DESC)
        AS rn
    FROM hacker_news 
    WHERE type = 'story'
)

SELECT
    year,
    month,
    title,
    hn_url,
    score
FROM ranked_stories
WHERE rn = 1
ORDER BY year, month