with other_artists as (
    select
        *
    from {{ ref('other_artists') }}
), 

official as (
    select
        track_name
        , track_artist
    from {{ ref('int_combined_song_list') }}
),

tiktok_top as (
    select
        strftime('%Y-%m', date) as year_month
        , track_name
        , track_author
        , rank() over (partition by year_month order by viral_video_count desc) as rank_by_videos
        , rank() over (partition by year_month order by views desc) as rank_by_views
        , views
        , viral_video_count
        , case 
            when views like '%B%' then cast(replace(views, 'B views', '') as decimal(10,1)) * 1000000000
            WHEN views LIKE '%M%' THEN CAST(REPLACE(views, 'M views', '') as decimal(10,1)) * 1000000
            else cast(REPLACE(views, ' views', '') AS DECIMAL(10,0))
        end as views_cleaned
        , case 
            when viral_video_count like '%K%' then cast(replace(viral_video_count, 'K popular videos', '') as decimal(10,1)) * 1000
            when viral_video_count like '%k%' then cast(replace(viral_video_count, 'k popular videos', '') as decimal(10,1)) * 1000
            else cast(replace(viral_video_count, ' popular videos', '') as decimal(10,1))
        end as viral_video_count_cleaned
        , case
            when viral_video_count_cleaned != 0 then views_cleaned / viral_video_count_cleaned
            else 0
            end as avg_views_per_viral_video
        , case when lower(track_name) like '%original sound%' then 'original sound'
            when track_name in (select track_name from official) 
                or track_author in (select distinct track_artist from official)  
                or track_author in (select artist_list from other_artists)
                then 'official song'
            else 'undetermined'
            end as audio_category
        , case when date > '2020-03-01' then 'post-covid' 
            else 'pre-covid'
            end as era
    from {{ ref('stg_tiktok_top_audio') }}
), 

final_cleaned as (
    select
        year_month
        , track_name
        , track_author
        , rank_by_videos
        , rank_by_views
        , views_cleaned as views
        , viral_video_count_cleaned as viral_video_count
        , avg_views_per_viral_video
        , audio_category
        , era
    from tiktok_top
)

select *
from final_cleaned