with
    trends as (
        select
            date
            , sport_name
            , trend
        from {{ ref('stg_web_scraping__google_trends_sports_normalized') }}
    )

    , sports as (
        select
            id
            , name
        from {{ ref('stg_olympics_api__sports') }}
    )

    , joining as (
        select
            sports.id as sport_id
            , date
            , trend
        from sports
        inner join trends on trends.sport_name = concat(sports.name, ' Olympics')
    )

select *
from joining