{{ config
    ({
    "post-hook": "{{ missing_member_column(primary_key = 'dim_yt_channel_sk') }}"
    })
}}

WITH prep_yt_channel AS (
    SELECT
    *
    FROM {{ref('prep_yt_channel')}}
)
SELECT
*,
get_current_timestamp() as etl_timestamp
FROM prep_yt_channel