with
    source as (
        select
            code as athlete_id
            , twitter_handle as username
            , {{ convert_abbreviated_numbers_to_int('followers') }} as followers
            , {{ convert_abbreviated_numbers_to_int('tweets') }} as tweets
            , {{ convert_abbreviated_numbers_to_int('followers_30_days') }} as followers_30_days
            , {{ convert_abbreviated_numbers_to_int('tweets_30_days') }} as tweets_30_days
        from {{ source('web_scraping', 'socialblade_twitter_metrics') }}
        where followers != 'null'
    )

select distinct *
from source