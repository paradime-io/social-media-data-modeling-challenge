with
    source as (
        select
            code as athlete_id
            , channel
            , {{ convert_abbreviated_numbers_to_int('subscribers') }} as subscribers
            , {{ convert_abbreviated_numbers_to_int('video_views') }} as video_views
            , {{ convert_abbreviated_numbers_to_int('uploads') }} as uploads
            , {{ convert_abbreviated_numbers_to_int('subscribers_30_days') }} as subscribers_30_days
            , {{ convert_abbreviated_numbers_to_int('video_views_30_days') }} as video_views_30_days
        from {{ source('web_scraping', 'socialblade_youtube_metrics') }}
        where subscribers != 'null'
    )

select distinct *
from source