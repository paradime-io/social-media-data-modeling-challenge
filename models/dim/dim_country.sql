WITH prep_yt_country AS (
    SELECT
    *
    FROM {{ref('prep_yt_country')}}
)
SELECT
*,
get_current_timestamp() as etl_timestamp
FROM prep_yt_country