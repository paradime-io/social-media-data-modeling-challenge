with source as (
    select
        case when _source like 'https%' then
            date_trunc('month', strptime(substring(_source, instr(_source, 'months/') + 7), '%B-%Y'))
        end as date
        , title as track_name
        , artist as track_author
        , rank as rank_by_videos
        , views
        , popularVideos as viral_video_count
    from {{ source('main', 'tiktok_top_100') }}
)

select *
from source