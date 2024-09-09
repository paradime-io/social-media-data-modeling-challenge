with
    source as (
        select
            date
            , sport as sport_name
            , trends as trend
        from {{ source('web_scraping', 'google_trends_sports_normalized') }}
    )

select distinct *
from source