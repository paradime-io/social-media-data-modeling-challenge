WITH distinct_yt_thumbnail AS (
    SELECT DISTINCT
        thumbnail_link
    FROM {{ ref('stg_yt_trending') }}
)
, add_keys AS (
    SELECT
        {{dbt_utils.generate_surrogate_key(['thumbnail_link'])}} AS dim_yt_thumbnail_sk,
        thumbnail_link,
        get_current_timestamp() as etl_timestamp
    FROM distinct_yt_thumbnail
)
SELECT
    dim_yt_thumbnail_sk,
    thumbnail_link,
    etl_timestamp
FROM add_keys
