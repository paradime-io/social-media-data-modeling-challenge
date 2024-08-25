WITH stg_yt_trending AS (
    SELECT 
    *
    FROM  {{ source('main', 'trending_daily') }}
)

SELECT * FROM stg_yt_trending