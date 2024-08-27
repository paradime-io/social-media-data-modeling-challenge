WITH base AS (
SELECT
    video_id,
    claim_status
FROM {{source('main', 'tiktok_dataset')}}
)

SELECT * FROM base