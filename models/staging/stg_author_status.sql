WITH base AS (
SELECT
    video_id,
    author_ban_status
FROM {{source('main', 'tiktok_dataset')}}
)

SELECT * FROM base 