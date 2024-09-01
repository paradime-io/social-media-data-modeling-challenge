with source as (
    select
        CASE WHEN _source LIKE 'https%' THEN
            DATE_TRUNC('month', STRPTIME(SUBSTRING(_source, INSTR(_source, 'months/') + 7), '%B-%Y'))
        END as date
        , title
        , artist
        , rank as rank_by_videos
        , views
        , popularVideos as viral_video_count
    from {{ source('source', 'tiktok_top_100') }}
)

select *
from source