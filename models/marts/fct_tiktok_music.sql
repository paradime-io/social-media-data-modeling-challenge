WITH base as (
    SELECT 
        *
    FROM {{ ref('int_tiktok_music_joined')}}
)

SELECT * FROM base
