with
    source as (
        select
            channel_id
            , channel_urls as channel_url
            , {{ convert_abbreviated_numbers_to_int("regexp_replace(subscriber_count, '\s?subscribers?$', '')") }} as subscribers
            , {{ convert_abbreviated_numbers_to_int("regexp_replace(view_count, '\s?views?$', '')") }} as video_views
            , {{ convert_abbreviated_numbers_to_int("regexp_replace(video_count, '\s?videos?$', '')") }} as uploads
        from {{ source('web_scraping', 'youtube_metrics') }}
        where subscriber_count is not null
    )

select distinct *
from source