WITH prep_yt_channel AS (
    SELECT
    *
    FROM {{ref('prep_yt_channel')}}
)
SELECT
*,
get_current_timestamp() as etl_timestamp
FROM prep_yt_channel