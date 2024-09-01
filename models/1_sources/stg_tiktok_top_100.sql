with source as (
    select
        CASE WHEN _source LIKE 'https%' THEN
            DATE_TRUNC('month', STRPTIME(SUBSTRING(_source, INSTR(_source, 'months/') + 7), '%B-%Y'))
        END as date
        , title as track_name
        , artist as track_author
        , rank as rank_by_videos
        , views
        , popularVideos as viral_video_count
    from {{ source('main', 'tiktok_top_100') }}
)

select *
from source