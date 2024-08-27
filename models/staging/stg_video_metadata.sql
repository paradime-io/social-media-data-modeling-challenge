SELECT
    video_id,
    video_duration_sec,
    verified_status,
    author_ban_status,
    claim_status
FROM {{source('main', 'tiktok_dataset')}}