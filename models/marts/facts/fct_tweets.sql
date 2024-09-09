with
    countries as (
        select
            id as country_id
            , lower(name) as country_name
        from {{ ref('country_codes') }}
    )

    , sports as (
        select
            id as sport_id
            , lower(name) as sport_name
        from {{ ref('stg_olympics_api__sports') }}
    )

    , athletes as (
        select
            id as athlete_id
            , lower(full_name) as athlete_full_name
        from {{ ref('int_athletes_bio_pivoted') }}
        where full_name is not null
    )

    , tweets as (
        select
            id
            , text
            , sentiment
        from {{ ref('stg_web_scraping__tweets') }}
    )

    , matching_athletes as (
        select
            tweets.id
            , tweets.text
            , tweets.sentiment
            , athletes.athlete_id
        from tweets
        inner join athletes on tweets.text like concat('%', athletes.athlete_full_name, '%')
    )

    , matching_sports as (
        select
            tweets.id
            , tweets.text
            , tweets.sentiment
            , sports.sport_id
        from tweets
        inner join sports on tweets.text like concat('%', sports.sport_name, '%')
    )

    , matching_countries as (
        select
            tweets.id
            , tweets.text
            , tweets.sentiment
            , countries.country_id
        from tweets
        inner join countries on tweets.text like concat('%', countries.country_name, '%')
    )

   , unioning as (
        select
            id
            , text
            , sentiment
            , athlete_id
            , null as sport_id
            , null as country_id
        from matching_athletes
        union all
        select
            id
            , text
            , sentiment
            , null as athlete_id
            , sport_id
            , null as country_id
        from matching_sports
        union all
        select
            id
            , text
            , sentiment
            , null as athlete_id
            , null as sport_id
            , country_id
        from matching_countries
    )

select *
from unioning