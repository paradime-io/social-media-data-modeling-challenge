with other_artists as (
    select
        *
    from {{ ref('other_artists') }}
), 

author as (
    select
        track_author
        , case when track_author in (select distinct track_author from {{ ref('int_audio_performance')}}) then 'official artist'
        or track_author in (select artist_list from other_artists)
        else 'other / tiktok user'
        end as author_category
        , count(track_name) as audio_count
        -- view metrics
        , sum(total_views) as total_views
        , sum(top10_vw_app) as top_10_app_count
        , sum(top100_vw_app) as top_100_app_count
        , round(avg(performance_score_by_views), 2) as avg_performance_score
        , round(avg(consistency_score_by_views), 2) as avg_consistency_score
        , round(avg(peak_score_by_views), 2) as avg_peak_score
        -- video metrics
        , sum(total_viral_videos) as total_viral_videos
        , sum(top10_vid_app) as top_10_app_count_vid
        , sum(top100_vid_app) as top_100_app_count_vid
        , round(avg(performance_score_by_videos), 2) as avg_performance_score_vid
        , round(avg(consistency_score_by_videos), 2) as avg_consistency_score_vid
        , round(avg(peak_score_by_videos), 2) as avg_peak_score_vid
    from {{ ref('int_audio_performance') }}
    where  
        track_author is not null
    group by 1
)

select *
from author