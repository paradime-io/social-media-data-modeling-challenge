WITH stg_yt_trending AS (
    SELECT 
    *
    FROM  {{ source('main', 'trending_daily') }}
   -- WHERE trending_date < '2024-09-02'
)

SELECT * FROM stg_yt_trending