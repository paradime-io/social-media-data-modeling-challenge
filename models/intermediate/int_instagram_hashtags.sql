WITH extracted AS (
    SELECT
        sid,
        {{ extract_hashtags('description') }}
    FROM {{ ref('stg_instagram') }}
),

filtered_hashtags AS (
    SELECT
        sid,
        hashtag
    FROM extracted
    WHERE hashtag LIKE '#%'
)

SELECT
    sid,
    hashtag
FROM filtered_hashtags
