WITH base AS (
SELECT
    video_id,
    video_view_count,
    video_like_count,
    video_share_count,
    video_download_count,
    video_comment_count
FROM {{source('main', 'tiktok_dataset')}}
)

SELECT * FROM base 
