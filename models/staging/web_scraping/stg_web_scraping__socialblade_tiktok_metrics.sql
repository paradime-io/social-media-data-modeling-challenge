with
    source as (
        select
            code as athlete_id
            , username
            , {{ convert_abbreviated_numbers_to_int('followers') }} as followers
            , {{ convert_abbreviated_numbers_to_int('likes') }} as likes
            , {{ convert_abbreviated_numbers_to_int('uploads') }} as uploads
            , {{ convert_abbreviated_numbers_to_int('followers_30_days') }} as followers_30_days
            , {{ convert_abbreviated_numbers_to_int('likes_30_days') }} as likes_30_days
            , {{ convert_abbreviated_numbers_to_int('uploads_30_days') }} as uploads_30_days
        from {{ source('web_scraping', 'socialblade_tiktok_metrics') }}
        where followers != 'null'
    )

select distinct *
from source