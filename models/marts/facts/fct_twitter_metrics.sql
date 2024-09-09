with

    socialblade as (
        select
            athlete_id
            , username
            , followers
            , tweets
            , followers_30_days
            , tweets_30_days
        from {{ ref('stg_web_scraping__socialblade_twitter_metrics') }}
    )

    , new_metrics as (
        select
            athlete_id
            , username as account
            , followers
            , tweets
            , followers_30_days
            , tweets_30_days
            , followers_30_days/(followers - followers_30_days) as followers_30_days_percentage
            , tweets_30_days/(tweets - tweets_30_days) as tweets_30_days_percentage
        from socialblade
    )

select *
from new_metrics
where followers is not null