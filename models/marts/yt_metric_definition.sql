{{ 
    config(materialized = 'table') 
}}

with combined_data as (
select *
from {{ ref('yt_combined_data') }}
)


select *, 
       strftime('%A', publish_date) as publish_day,
       concat(year(snapshot_date), '-', month(snapshot_date)) as snapshot_year_month,
       (coalesce(like_count, 0) + (2 * coalesce(comment_count, 0)))/view_count as engagement_rate,
       array_length(string_split(title, ' ')) AS title_word_count,
       array_length(string_split(video_tags, ', ')) AS video_tags_word_count,
       length(description) as description_length
from
combined_data 