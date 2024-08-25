WITH video_categories as (
    SELECT 
        "Category ID",
        "Title" as youtube_category
    FROM Youtube_video_category_PH
)

SELECT
    video_id,
    'Philippines'as country,
    {{ dbt_utils.generate_surrogate_key(['video_id', 'country']) }} as youtube_video_key,
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
    {{ source('dbt_paradime_nancy_amandi', 'Philippines_Youtube') }} ph
LEFT JOIN
    video_categories vc
ON vc."Category ID" = ph.categoryId

