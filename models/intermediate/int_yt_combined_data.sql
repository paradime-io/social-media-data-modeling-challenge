{{ 
    config(materialized = 'table') 
}}

with trending_yt_videos as (
    select *
    from {{ ref('stg_trending_yt_videos') }}
),

video_details as (
    select *
    from {{ ref('stg_video_details') }}
),

category_mapping as (
    select *
    from {{ ref('stg_category_mapping') }}
),

title_description_emoji_presence as (
    select *
    from {{ ref('stg_title_description_emoji_presence') }}
),

thumbnail_analysis as (
    select *
    from {{ ref('stg_thumbnail_analysis') }}
),

country_cpm_rates as (
    select *
    from {{ ref('stg_country_cpm_rates') }}
),

category_cpm_rates as (
    select *
    from {{ ref('stg_category_cpm_rates') }}
),


combined_data as (

    select distinct
        a.*,

        b.total_minutes,
        b.caption,

        c.category_name,

        d.title_emoji_flag,
        d.title_excluding_emoji,

        e.description_emoji_flag,
        e.description_excluding_emoji,

        f.text_present_flag,
        f.face_present_flag,

        g.country_cpm_rate,

        h.category_cpm_rate

    from
        trending_yt_videos as a

    left join

        video_details as b
        on a.video_id = b.video_id

    left join

        category_mapping as c
        on b.category_id = c.category_id

    left join

        (select distinct
                video_id,
                title,
                title_emoji_flag,
                title_excluding_emoji
            from title_description_emoji_presence
        ) as d
        on a.video_id = d.video_id
            and a.title = d.title

    left join

        (select distinct
                video_id,
                description,
                description_emoji_flag,
                description_excluding_emoji
            from title_description_emoji_presence
        ) as e
        on a.video_id = e.video_id
            and a.description = e.description

    left join

        thumbnail_analysis as f
        on a.thumbnail_url = f.thumbnail_url

    left join

        country_cpm_rates as g
        on a.country_id = g.country_id

    left join

        category_cpm_rates as h
        on c.category_name = h.category_name
)

select
    *,

    -- Metric Creation

    -- Day of the week corresponding to publish date.
    strftime('%A', publish_date) as publish_day,

    -- Day of the week corresponding to trending date.
    strftime('%A', trending_date) as trending_day,

    -- Number of days between the video publish date and trending date.
    datediff('day', publish_date, trending_date) as days_to_trend,

    -- Guages audience engagement
    (coalesce(like_count, 0) + (2 * coalesce(comment_count, 0))) / view_count as engagement_rate,

    -- Number of words present in the video tiitle (after excluding all emojis).
    array_length(string_split(trim(title_excluding_emoji), ' ')) as title_word_count,

    -- Number of tags present in the video.
    array_length(string_split(trim(video_tags), ', ')) as video_tags_word_count,

    -- Number of characters present in the video description (after excluding all emojis).
    length(trim(description_excluding_emoji)) as description_length,

    -- Calculations for Estimated RPM per minute of the video

    -- Not all views on YouTube are monetized. Based on industry estimates, 
    -- around 70% of views generate ad revenue, accounting for factors such as ad blockers, non-monetizable content.
    (view_count * 0.7) as monetized_views,

    -- Estimated Cost per Mille (CPM) wrt country CPM rates.
    (monetized_views / 1000) * country_cpm_rate as country_cpm_revenue,

    -- Estimated Cost per Mille (CPM) wrt category CPM rates.
    (monetized_views / 1000) * category_cpm_rate as category_cpm_revenue,

    -- Average of country CPM and category CPM considering revenue share of the Youtuber is 55%. 
    -- CPM of a video depends on both the geography and category of the video.
    ((country_cpm_revenue + category_cpm_revenue) / 2) * 0.55 as estimated_revenue_for_youtuber,

    -- Estimated Revenue per mille (RPM).
    (estimated_revenue_for_youtuber * 1000) / view_count as estimated_rpm_for_youtuber,

    -- Average estimated RPM per minute of the video.
    estimated_rpm_for_youtuber / total_minutes as estimated_rpm_per_minute

from combined_data
