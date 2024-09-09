with
    athletes as (
        select
            id
            , instagram_url
        from {{ ref('int_athletes_bio_pivoted') }}
        where instagram_url is not null
    )

    , instagram_website as (
        select
           username
            , followers
        from {{ ref('stg_web_scraping__instagram_metrics') }}
    )

    , joining as (
        select
            athletes.id as athlete_id
            , instagram_website.username as account
            , instagram_website.followers as followers
        from athletes
        left join instagram_website
            on athletes.instagram_url like concat('%/', instagram_website.username)
            or athletes.instagram_url like concat('%/', instagram_website.username, '/%')
    )

select *
from joining
where followers is not null