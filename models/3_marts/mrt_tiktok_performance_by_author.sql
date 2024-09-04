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
    , avg(performance_score_by_views) as avg_performance_score
    , avg(consistency_score_by_views) as avg_consistency_score
    , avg(peak_score_by_views) as avg_peak_score
    -- video metrics
    , sum(total_viral_videos) as total_viral_videos
    , sum(top10_vid_app) as top_10_app_count_vid
    , sum(top100_vid_app) as top_100_app_count_vid
    , avg(performance_score_by_videos) as avg_performance_score_vid
    , avg(consistency_score_by_videos) as avg_consistency_score_vid
    , avg(peak_score_by_videos) as avg_peak_score_vid
from {{ ref('int_audio_performance') }}
group by 1
)

select *
from author