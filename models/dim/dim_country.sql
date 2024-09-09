{{
    config(
        materialized='incremental',
        unique_key='dim_yt_country_sk',
        post_hook="{{ missing_member_column(primary_key='dim_yt_country_sk') }}"
    )

}}


WITH prep_yt_country AS (
    SELECT
    *
    FROM {{ref('prep_yt_country')}}
)
SELECT
*,
get_current_timestamp() as etl_timestamp
FROM prep_yt_country