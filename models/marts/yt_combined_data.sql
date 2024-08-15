{{ 
    config(materialized = 'table') 
}}

with trending_yt_videos as (
select *
from {{ source('source', 'trending_yt_videos_113_countries') }}
),

video_details as (
select *
from {{ ref('stg_video_details') }}
),

category_mapping as (
select *
from {{ source('source', 'category_mapping') }}
)


select a.*, b.duration, b.total_seconds, b.total_minutes, b.caption, b.category_id, c.category_name
from 
trending_yt_videos a

left join

video_details b
on a.video_id = b.video_id

left join

category_mapping c
on b.category_id = c.category_id
