{{ 
    config(materialized = 'table') 
}}

with trending_youtube_videos as (
select title,
       snapshot_date as trending_date,
       country,
       view_count,
       like_count,
       comment_count,
       description,
       thumbnail_url,
       video_id,
       video_tags,
       publish_date
from {{ source('source', 'trending_yt_videos_113_countries') }}
)

select *
from trending_youtube_videos



