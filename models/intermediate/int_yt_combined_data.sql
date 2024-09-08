{{ 
    config(materialized = 'table') 
}}

with trending_yt_videos as (
select *
from {{ ref('stg_trending_youtube_videos') }}
),

video_details as (
select *
from {{ ref('stg_video_details') }}
),

category_mapping as (
select *
from {{ ref('stg_category_mapping') }}
),

title_description_emoji_presence as (
select *
from {{ ref('stg_title_description_emoji_presence') }}
),

thumbnail_analysis as (
select *
from {{ ref('stg_thumbnail_analysis') }}
),

country_cpm_rates as (
select *
from {{ ref('stg_country_cpm_rates') }}
),

category_cpm_rates as (
select *
from {{ ref('stg_category_cpm_rates') }}
)


select a.*, 

       b.total_minutes, b.caption, 

       c.category_name, 

       d.title_emoji_flag, d.title_excluding_emoji,

       e.description_emoji_flag, e.description_excluding_emoji,

       f.text_present_flag, f.face_present_flag,

       g.country_cpm_rate,
       
       h.category_cpm_rate
from 
trending_yt_videos a

left join

video_details b
on a.video_id = b.video_id

left join

category_mapping c
on b.category_id = c.category_id

left join

title_description_emoji_presence d
on a.video_id = d.video_id
and a.title = d.title

left join

title_description_emoji_presence e
on a.video_id = e.video_id
and a.description = e.description

left join

thumbnail_analysis f
on a.thumbnail_url = f.thumbnail_url

left join

country_cpm_rates g
on a.country = g.country

left join

category_cpm_rates h
on c.category_name = h.category_name