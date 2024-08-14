SELECT
    YEAR(timestamp) AS year,
    MONTH(timestamp) AS month,
    COUNT(*) AS keyword_mentions
FROM {{ source('hn', 'hacker_news') }} 
WHERE
    1=1 AND (title LIKE '%duckdb%' OR text LIKE '%duckdb%')
GROUP BY year, month
ORDER BY year ASC, month ASC