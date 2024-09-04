with view_aggregates as (
    select
        track_name
        , track_author
        , audio_category
        -- by views
        , sum(views) as total_views
        , count(track_name) as top100_vw_app
        , sum(case when rank_by_views <= 10 then 1 else 0 end) as top10_vw_app
        , avg(rank_by_views) as avg_top100_vw_rank
        , min(rank_by_views) as max_vw_rank
        -- by viral videos
        , sum(viral_video_count) as total_viral_videos
        , count(track_name) as top100_vid_app
        , sum(case when rank_by_videos <= 10 then 1 else 0 end) as top10_vid_app
        , avg(rank_by_videos) as avg_top100_vid_rank
        , min(rank_by_videos) as max_vid_rank

    from
        {{ ref('int_tiktok_top_audio_cleaned') }}
    group by
        track_name, track_author, audio_category
), 

normalized_factors as (
    select
        -- by views
        max(total_views) as max_views, min(total_views) as min_views
        , max(top100_vw_app) as max_top100, min(top100_vw_app) as min_top100
        , max(top10_vw_app) as max_top10, min(top10_vw_app) as min_top10
        , min(avg_top100_vw_rank) as max_avg_top100, max(avg_top100_vw_rank) as min_avg_top100
        -- by viral videos
        , max(total_viral_videos) as max_viral_videos, min(total_viral_videos) as min_viral_videos
        , max(top100_vid_app) as max_top100_vid, min(top100_vid_app) as min_top100_vid
        , max(top10_vid_app) as max_top10_vid, min(top10_vid_app) as min_top10_vid
        , min(avg_top100_vid_rank) as max_avg_top100_vid, max(avg_top100_vid_rank) as min_avg_top100_vid
        , 1 as max_rank, 100 as min_rank
    from view_aggregates
), 

normalized_view_aggregates as (
    select
        track_name
        , track_author
        , audio_category
        -- by views
        , total_views
        , top100_vw_app
        , top10_vw_app
        , avg_top100_vw_rank
        , max_vw_rank
        , (v.total_views - nf.min_views) / (nf.max_views - nf.min_views) as norm_total_views
        , (v.top100_vw_app - nf.min_top100) / (nf.max_top100 - nf.min_top100) as norm_top100_app
        , (v.top10_vw_app - nf.min_top10) / (nf.max_top10 - nf.min_top10) as norm_top10_app
        , (nf.min_avg_top100 - v.avg_top100_vw_rank) / (nf.min_avg_top100 - nf.max_avg_top100) as norm_avg_top100_rank
        , (nf.min_rank - v.max_vw_rank) / (nf.min_rank - nf.max_rank) as norm_max_rank
        -- by viral videos
        , total_viral_videos
        , top100_vid_app
        , top10_vid_app
        , avg_top100_vid_rank
        , max_vid_rank
        , (v.total_viral_videos - nf.min_viral_videos) / (nf.max_viral_videos - nf.min_viral_videos) as norm_total_videos
        , (v.top100_vid_app - nf.min_top100_vid) / (nf.max_top100_vid - nf.min_top100_vid) as norm_top100_app_vid
        , (v.top10_vid_app - nf.min_top10_vid) / (nf.max_top10_vid - nf.min_top10_vid) as norm_top10_app_vid
        , (nf.min_avg_top100_vid - v.avg_top100_vid_rank) / (nf.min_avg_top100_vid - nf.max_avg_top100_vid) as norm_avg_top100_rank_vid
        , (nf.min_rank - v.max_vid_rank) / (nf.min_rank - nf.max_rank) as norm_max_rank_vid
        , total_views / total_viral_videos as avg_views_per_viral_video
    from
        view_aggregates v, normalized_factors nf
),

view_metrics as (
    select
        *
        , {{ calculate_performance_scores(
                'norm_total_views'
                , 'norm_top100_app'
                , 'norm_top10_app'
                , 'norm_avg_top100_rank'
                , 'norm_max_rank'
            ) }}
    from normalized_view_aggregates
),

video_metrics as (
    select
        *
        , {{ calculate_performance_scores(
                'norm_total_videos'
                , 'norm_top100_app_vid'
                , 'norm_top10_app_vid'
                , 'norm_avg_top100_rank_vid'
                , 'norm_max_rank_vid'
            ) }}
    from normalized_view_aggregates
),

final as (
select
    a.track_name
    , a.track_author
    , a.audio_category
    -- by views
    , a.total_views
    , round(a.top100_vw_app, 2) as top100_vw_app
    , round(a.top10_vw_app, 2) as top10_vw_app
    , round(a.avg_top100_vw_rank, 2) as avg_top100_vw_rank
    , round(a.max_vw_rank, 2) as max_vw_rank
    , round(a.norm_total_views, 2) as norm_total_views
    , round(a.norm_top100_app, 2) as norm_top100_app
    , round(a.norm_top10_app, 2) as norm_top10_app
    , round(a.norm_avg_top100_rank, 2) as norm_avg_top100_rank
    , round(a.norm_max_rank, 2) as norm_max_rank
    , round(a.base_performance_score, 2) as performance_score_by_views
    , round(a.consistency_score, 2) as consistency_score_by_views
    , round(a.peak_score, 2) as peak_score_by_views
    -- by viral videos
    , a.total_viral_videos
    , round(a.top100_vid_app, 2) as top100_vid_app
    , round(a.top10_vid_app, 2) as top10_vid_app
    , round(a.avg_top100_vid_rank, 2) as avg_top100_vid_rank
    , round(a.max_vid_rank, 2) as max_vid_rank
    , round(a.norm_total_videos, 2) as norm_total_videos
    , round(a.norm_top100_app_vid, 2) as norm_top100_app_vid
    , round(a.norm_top10_app_vid, 2) as norm_top10_app_vid
    , round(a.norm_avg_top100_rank_vid, 2) as norm_avg_top100_rank_vid
    , round(a.norm_max_rank_vid, 2) as norm_max_rank_vid
    , round(b.base_performance_score, 2) as performance_score_by_videos
    , round(b.consistency_score, 2) as consistency_score_by_videos
    , round(b.peak_score, 2) as peak_score_by_videos
    , round(a.total_views / a.total_viral_videos, 0) as avg_views_per_viral_video,

from view_metrics a
join video_metrics b on a.track_name = b.track_name and a.track_author = b.track_author
)

select *
from final