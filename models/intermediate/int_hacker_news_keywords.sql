WITH keywords_occurences AS (
    SELECT 
        UPPER(technologyKeys) AS technologyKeys,
        title
    FROM {{ ref('stg_hacker_news') }}
    CROSS JOIN {{ ref('technologyKeywords') }}
    WHERE UPPER(title) LIKE CONCAT('% ', UPPER(technologyKeys), ' %')
),
total_keywords AS (
    SELECT 
        technologyKeys,
        COUNT(*) AS ocurrences
    FROM keywords_occurences
    GROUP BY technologyKeys
    ORDER BY ocurrences
)
SELECT 
    *
FROM total_keywords
ORDER BY ocurrences DESC