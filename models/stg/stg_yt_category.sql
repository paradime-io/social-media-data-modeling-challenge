WITH stg_yt_category AS (
    SELECT
    *
    FROM {{ source('main', 'category_daily') }}
)

SELECT * FROM stg_yt_category