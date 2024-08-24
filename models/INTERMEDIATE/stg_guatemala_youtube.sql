WITH video_categories as (
    SELECT 
        "Category ID",
        "Title" as youtube_category,
        region_code
    FROM combined_video_categories
    WHERE region_code = 'GT'
)

SELECT
    video_id,
    'Guatemala' as country,
    title as video_title,
    publishedAt as published_at,
    channelTitle as youtube_channel,
    youtube_category,
    STRPTIME(trending_date, '%y.%d.%m') AS trending_date,
    tags,
    view_count,
    likes,
    dislikes,
    comment_count,
    thumbnail_link,
    comments_disabled,
    ratings_disabled,
    description
FROM 
    {{ source('dbt_paradime_nancy_amandi', 'Guatemala_Youtube') }} gt
LEFT JOIN
    video_categories vc
ON vc."Category ID" = gt.categoryId

