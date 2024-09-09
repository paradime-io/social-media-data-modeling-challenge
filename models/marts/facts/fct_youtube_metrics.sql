with
    athletes as (
        select
            id
            , youtube_url
        from {{ ref('int_athletes_bio_pivoted') }}
        where youtube_url is not null
    )

    , socialblade as (
        select
            athlete_id
            , channel
            , subscribers
            , video_views
            , uploads
            , subscribers_30_days
            , video_views_30_days
        from {{ ref('stg_web_scraping__socialblade_youtube_metrics') }}
    )

    , youtube_website as (
        select
           channel_id
            , channel_url
            , subscribers
            , video_views
            , uploads
        from {{ ref('stg_web_scraping__youtube_metrics') }}
    )

    , youtube_channels as (
        select
            athlete_id
            , username
        from {{ ref('youtube_channels') }}
    )

    , joining as (
        select
            athletes.id as athlete_id
            , youtube_channels.username as account
            , coalesce(socialblade.subscribers, youtube_website.subscribers) as subscribers
            , coalesce(socialblade.video_views, youtube_website.video_views) as video_views
            , coalesce(socialblade.uploads, youtube_website.uploads) as uploads
            , socialblade.subscribers_30_days
            , socialblade.video_views_30_days
            , socialblade.subscribers_30_days/(socialblade.subscribers - socialblade.subscribers_30_days) as subscribers_30_days_percentage
            , socialblade.video_views_30_days/(socialblade.video_views - socialblade.video_views_30_days) as video_views_30_days_percentage
        from athletes
        inner join youtube_channels on athletes.id = youtube_channels.athlete_id
        left join socialblade on athletes.id = socialblade.athlete_id
        left join youtube_website
            on youtube_website.channel_url like concat('%', youtube_channels.username)
            or youtube_website.channel_id = youtube_channels.username
    )

select *
from joining
where subscribers is not null