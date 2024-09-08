{{ 
    config(materialized = 'table') 
}}

with combined_data as (
select *
from {{ ref('int_yt_combined_data') }}
)

select *, 
       strftime('%A', publish_date) as publish_day, 

       strftime('%A', trending_date) as trending_day,

       datediff('day', publish_date, trending_date) as days_to_trend,

       (coalesce(like_count, 0) + (2 * coalesce(comment_count, 0)))/view_count as engagement_rate,

       array_length(string_split(trim(title_excluding_emoji), ' ')) AS title_word_count,

       array_length(string_split(trim(video_tags), ', ')) AS video_tags_word_count,

       length(trim(description_excluding_emoji)) as description_length,

        -- Calculations for Estimated RPM per minute of the video

       (view_count * 0.7) as monetized_views,

       (monetized_views/1000) * country_cpm_rate as country_cpm_revenue,

       (monetized_views/1000) * category_cpm_rate as category_cpm_revenue,

       ((country_cpm_revenue + category_cpm_revenue)/2) * 0.55 as estimated_revenue_for_youtuber,

       (estimated_revenue * 1000)/view_count as estimated_rpm,
       
        estimated_rpm/total_minutes as estimated_rpm_per_minute
from
combined_data 