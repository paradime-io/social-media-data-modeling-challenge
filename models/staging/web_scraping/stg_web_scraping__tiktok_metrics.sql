with
    source as (
        select
            username
            , "followers.raw" as followers
            , "likes.raw" as likes
            , "videos.raw" as uploads
        from {{ source('web_scraping', 'tiktok_metrics') }}
    )

select distinct *
from source
