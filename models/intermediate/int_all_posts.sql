WITH all_posts AS (
    SELECT 
        'Hacker News' AS media,
        *
    FROM {{ ref('stg_hacker_news') }}

    UNION

    SELECT 
        'Slashdot' AS media,
        *
    FROM {{ ref('stg_slashdot') }}
)
SELECT 
    *
FROM all_posts