WITH stg_yt_trending AS (
    SELECT 
        video_id,
        title,
        publishedAt,
        channelId,
        channelTitle,
        categoryId,
        country,
        CAST(trending_date as DATE) trending_date,
        tags,
        view_count,
        likes,
        comment_count,
        thumbnail_link,
        comments_disabled,
        ratings_disabled,
        description
    FROM  {{ source('main', 'trending_daily') }}
)

SELECT * FROM stg_yt_trending