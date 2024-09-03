WITH view_aggregates AS (
    SELECT
        track_name,
        track_author,
        SUM(views) AS total_views,
        SUM(CASE WHEN rank_by_views <= 50 THEN 1 END) AS top50_vw_app,
        SUM(CASE WHEN rank_by_views <= 10 THEN 1 END) AS top10_vw_app,
        AVG(CASE WHEN rank_by_views <= 50 THEN rank_by_views END) AS avg_top50_vw_rank,
        AVG(CASE WHEN rank_by_views <= 10 THEN rank_by_views END) AS avg_top10_vw_rank,
    FROM
        {{ ref('tiktok_top_audio_cleaned') }}
    GROUP BY
        track_name, track_author
), 

performance_scores_views as (
    SELECT
        track_name,
        {{ calculate_performance_scores('total views', 'top50_vw_app', 'top10_vw_app', 'avg_top50_vw_rank', 'avg_top10_vw_rank') }}
    FROM
        view_aggregates
), 

video_aggregates AS (
    SELECT
        track_name,
        track_author,
        SUM(viral_video_count) AS total_videos,
        SUM(CASE WHEN rank_by_views <= 50 THEN 1 END) AS top50_vid_app,
        SUM(CASE WHEN rank_by_views <= 10 THEN 1 END) AS top10_vid_app,
        AVG(CASE WHEN rank_by_views <= 50 THEN rank_by_views END) AS avg_top50_vid_rank,
        AVG(CASE WHEN rank_by_views <= 10 THEN rank_by_views END) AS avg_top10_vid_rank,
    FROM
        {{ ref('tiktok_top_audio_cleaned') }}
    GROUP BY
        track_name, track_author
), 

performance_scores_videos as (
    SELECT
        track_name,
        {{ calculate_performance_scores('total_videos', 'top50_vid_app', 'top10_vid_app', 'avg_top50_vid_rank', 'avg_top10_vid_rank') }}
    FROM
        video_aggregates
), 