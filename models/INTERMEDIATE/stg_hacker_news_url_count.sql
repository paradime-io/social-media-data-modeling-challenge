WITH https_count AS (
    SELECT word_between_slashes, 
    COUNT(word_between_slashes) AS url_count
    FROM (
    SELECT
        distinct url,
        regexp_extract(
        url,
        '^https://([^/]+)'
        ) AS word_between_slashes
    FROM {{ source('hn', 'hacker_news') }}
    WHERE url LIKE 'https%'
    )
    GROUP BY ALL
    ORDER BY COUNT(word_between_slashes) DESC
),
http_count AS (
    SELECT word_between_slashes, 
    COUNT(word_between_slashes) AS url_count
    FROM (
    SELECT
        distinct url,
        regexp_extract(
        url,
        '^http://([^/]+)'
        ) AS word_between_slashes
    FROM {{ source('hn', 'hacker_news') }}
    WHERE url NOT LIKE 'https%'
    )
    GROUP BY ALL
    ORDER BY COUNT(word_between_slashes) DESC
)
SELECT * FROM https_count
UNION ALL
SELECT * FROM http_count