with
    athletes as (
        select
            id
            , tiktok_url
        from {{ ref('int_athletes_bio_pivoted') }}
        where tiktok_url is not null
    )

    , socialblade as (
        select
            athlete_id
            , username
            , followers
            , likes
            , uploads
            , followers_30_days
            , likes_30_days
            , uploads_30_days
        from {{ ref('stg_web_scraping__socialblade_tiktok_metrics') }}
    )

    , tiktok_website as (
        select
            username
            , followers
            , likes
            , uploads
        from {{ ref('stg_web_scraping__tiktok_metrics') }}
    )

    , joining as (
        select
            athletes.id as athlete_id
            , coalesce(socialblade.username, tiktok_website.username) as account
            , coalesce(socialblade.followers, tiktok_website.followers) as followers
            , coalesce(socialblade.likes, tiktok_website.likes) as likes
            , coalesce(socialblade.uploads, tiktok_website.uploads) as uploads
            , socialblade.followers_30_days
            , socialblade.likes_30_days
            , socialblade.uploads_30_days
            , socialblade.followers_30_days/(socialblade.followers - socialblade.followers_30_days) as followers_30_days_percentage
            , socialblade.likes_30_days/(socialblade.likes - socialblade.likes_30_days) as likes_30_days_percentage
            , socialblade.uploads_30_days/(socialblade.uploads - socialblade.uploads_30_days) as uploads_30_days_percentage
        from athletes
        left join socialblade on athletes.id = socialblade.athlete_id
        left join tiktok_website on athletes.tiktok_url like concat('%', tiktok_website.username, '%')
    )

select *
from joining
where followers is not null