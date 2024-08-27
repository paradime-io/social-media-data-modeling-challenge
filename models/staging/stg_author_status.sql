WITH base AS (
SELECT
        video_id,
        verified_status,
        author_ban_status
FROM {{source('main', 'tiktok_dataset')}}
)

SELECT * FROM base 
