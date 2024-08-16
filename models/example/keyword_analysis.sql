WITH hacker_news AS (
    SELECT
    *
    FROM {{ source('hn', 'hacker_news') }}
)

SELECT
    YEAR(timestamp) AS year,
    MONTH(timestamp) AS month,
    COUNT(*) AS keyword_mentions
FROM hacker_news
WHERE
    (title LIKE '%duckdb%' OR text LIKE '%duckdb%')
GROUP BY year, month
ORDER BY year ASC, month ASC