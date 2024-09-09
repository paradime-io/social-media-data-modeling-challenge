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

    , reddit_posts_and_comments as (
        select
            id
            , type
            , text
            , sentiment
        from {{ ref('stg_web_scraping__reddit_posts_and_comments') }}
    )

    , matching_athletes as (
        select
            reddit_posts_and_comments.id
            , reddit_posts_and_comments.type
            , reddit_posts_and_comments.text
            , reddit_posts_and_comments.sentiment
            , athletes.athlete_id
        from reddit_posts_and_comments
        inner join athletes on reddit_posts_and_comments.text like concat('%', athletes.athlete_full_name, '%')
    )

    , matching_sports as (
        select
            reddit_posts_and_comments.id
            , reddit_posts_and_comments.type
            , reddit_posts_and_comments.text
            , reddit_posts_and_comments.sentiment
            , sports.sport_id
        from reddit_posts_and_comments
        inner join sports on reddit_posts_and_comments.text like concat('%', sports.sport_name, '%')
    )

    , matching_countries as (
        select
            reddit_posts_and_comments.id
            , reddit_posts_and_comments.type
            , reddit_posts_and_comments.text
            , reddit_posts_and_comments.sentiment
            , countries.country_id
        from reddit_posts_and_comments
        inner join countries on reddit_posts_and_comments.text like concat('%', countries.country_name, '%')
    )

   , unioning as (
        select
            id
            , type
            , text
            , sentiment
            , athlete_id
            , null as sport_id
            , null as country_id
        from matching_athletes
        union all
        select
            id
            , type
            , text
            , sentiment
            , null as athlete_id
            , sport_id
            , null as country_id
        from matching_sports
        union all
        select
            id
            , type
            , text
            , sentiment
            , null as athlete_id
            , null as sport_id
            , country_id
        from matching_countries
    )

select *
from unioning