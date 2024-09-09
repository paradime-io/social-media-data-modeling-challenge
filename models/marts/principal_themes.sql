WITH hacker_news_themes AS (
    SELECT 
        'hacker_news' AS media,
        *
    FROM {{ ref('int_hacker_news_keywords') }}
),
slashdot_themes AS (
    SELECT 
        'slashdot' AS media,
        *
    FROM {{ ref('int_slashdot_keywords') }}
),
themes_by_media AS (
    SELECT 
        *
    FROM hacker_news_themes

    UNION

    SELECT 
        *
    FROM slashdot_themes
)
SELECT 
    *,
    ( ocurrences / qtt_posts ) AS percent_ocurrences_total
FROM themes_by_media

