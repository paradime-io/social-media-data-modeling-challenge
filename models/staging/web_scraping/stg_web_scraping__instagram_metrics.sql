with
    source as (
        select
            userName as username
            , followersCount as followers
        from {{ source('web_scraping', 'instagram_metrics') }}
        where error is null
    )

select distinct *
from source