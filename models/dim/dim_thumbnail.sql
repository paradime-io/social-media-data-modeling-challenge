{{
    config(
    materialized='incremental',
    unique_key='dim_yt_thumbnail_sk',
    post_hook="{{ missing_member_column(primary_key='dim_yt_thumbnail_sk') }}"
    )
}}

WITH distinct_yt_thumbnail AS (
    SELECT DISTINCT
        thumbnail_link
    FROM {{ ref('stg_yt_trending') }}
    {% if is_incremental %}
    WHERE trending_date >= current_date - {{ var('days_to_load', 5) }}
    {% endif %}
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
