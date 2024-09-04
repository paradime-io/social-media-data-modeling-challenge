WITH view_aggregates AS (
    SELECT
        track_name
        , track_author
        , audio_category
        -- by views
        , SUM(views) AS total_views
        , COUNT(track_name) AS top100_vw_app
        , SUM(CASE WHEN rank_by_views <= 10 THEN 1 ELSE 0 END) AS top10_vw_app
        , AVG(rank_by_views) AS avg_top100_vw_rank
        , MIN(rank_by_views) AS max_vw_rank
        -- by viral videos
        , SUM(viral_video_count) as total_viral_videos
        , COUNT(track_name) AS top100_vid_app
        , SUM(CASE WHEN rank_by_videos <= 10 THEN 1 ELSE 0 END) AS top10_vid_app
        , AVG(rank_by_videos) AS avg_top100_vid_rank
        , MIN(rank_by_videos) AS max_vid_rank

    FROM
        {{ ref('int_tiktok_top_audio_cleaned') }}
    GROUP BY
        track_name, track_author, audio_category
), 

normalized_factors AS (
    SELECT
        -- by views
        MAX(total_views) AS max_views, MIN(total_views) AS min_views
        , MAX(top100_vw_app) AS max_top100, MIN(top100_vw_app) AS min_top100
        , MAX(top10_vw_app) AS max_top10, MIN(top10_vw_app) AS min_top10
        , MIN(avg_top100_vw_rank) AS max_avg_top100, MAX(avg_top100_vw_rank) AS min_avg_top100
        -- by viral videos
        , MAX(total_viral_videos) AS max_viral_videos, MIN(total_viral_videos) AS min_viral_videos
        , MAX(top100_vid_app) AS max_top100_vid, MIN(top100_vid_app) AS min_top100_vid
        , MAX(top10_vid_app) AS max_top10_vid, MIN(top10_vid_app) AS min_top10_vid
        , MIN(avg_top100_vid_rank) AS max_avg_top100_vid, MAX(avg_top100_vid_rank) AS min_avg_top100_vid
        , 1 AS max_rank, 100 AS min_rank
    FROM view_aggregates
), 

normalized_view_aggregates as (
    SELECT
        track_name
        , track_author
        , audio_category
        -- by views
        , total_views
        , top100_vw_app
        , top10_vw_app
        , avg_top100_vw_rank
        , max_vw_rank
        , (v.total_views - nf.min_views) / (nf.max_views - nf.min_views) AS norm_total_views
        , (v.top100_vw_app - nf.min_top100) / (nf.max_top100 - nf.min_top100) AS norm_top100_app
        , (v.top10_vw_app - nf.min_top10) / (nf.max_top10 - nf.min_top10) AS norm_top10_app
        , (nf.min_avg_top100 - v.avg_top100_vw_rank) / (nf.min_avg_top100 - nf.max_avg_top100) AS norm_avg_top100_rank
        , (nf.min_rank - v.max_vw_rank) / (nf.min_rank - nf.max_rank) AS norm_max_rank
        -- by viral videos
        , total_viral_videos
        , top100_vid_app
        , top10_vid_app
        , avg_top100_vid_rank
        , max_vid_rank
        , (v.total_viral_videos - nf.min_viral_videos) / (nf.max_viral_videos - nf.min_viral_videos) AS norm_total_videos
        , (v.top100_vid_app - nf.min_top100_vid) / (nf.max_top100_vid - nf.min_top100_vid) AS norm_top100_app_vid
        , (v.top10_vid_app - nf.min_top10_vid) / (nf.max_top10_vid - nf.min_top10_vid) AS norm_top10_app_vid
        , (nf.min_avg_top100_vid - v.avg_top100_vid_rank) / (nf.min_avg_top100_vid - nf.max_avg_top100_vid) AS norm_avg_top100_rank_vid
        , (nf.min_rank - v.max_vid_rank) / (nf.min_rank - nf.max_rank) AS norm_max_rank_vid
        , total_views / total_viral_videos as avg_views_per_viral_video
    FROM
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
)

select
    a.track_name
    , a.track_author
    , a.audio_category
    -- by views
    , a.total_views
    , a.top100_vw_app
    , a.top10_vw_app
    , a.avg_top100_vw_rank
    , a.max_vw_rank
    , a.norm_total_views
    , a.norm_top100_app
    , a.norm_top10_app
    , a.norm_avg_top100_rank
    , a.norm_max_rank
    , a.base_performance_score as performance_score_by_views
    , a.consistency_score as consistency_score_by_views
    , a.peak_score as peak_score_by_views
    -- by viral videos
    , a.total_viral_videos
    , a.top100_vid_app
    , a.top10_vid_app
    , a.avg_top100_vid_rank
    , a.max_vid_rank
    , a.norm_total_videos
    , a.norm_top100_app_vid
    , a.norm_top10_app_vid
    , a.norm_avg_top100_rank_vid
    , a.norm_max_rank_vid
    , b.base_performance_score as performance_score_by_videos
    , b.consistency_score as consistency_score_by_videos
    , b.peak_score as peak_score_by_videos
    , a.total_views / a.total_viral_videos as avg_views_per_viral_video,

from view_metrics a
join video_metrics b on a.track_name = b.track_name and a.track_author = b.track_author