WITH base AS (
SELECT
    video_id,
    video_transcription_text
FROM {{source('main', 'tiktok_dataset')}}
)

SELECT * FROM base