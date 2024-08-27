WITH base AS (
  SELECT
        video_id,
        video_duration_sec,
        video_transcription_text,
        verified_status,
        author_ban_status,
        COALESCE(TRY_CAST(video_view_count AS INTEGER), 0) AS video_view_count,
        COALESCE(TRY_CAST(video_like_count AS INTEGER), 0) AS video_like_count,
        COALESCE(TRY_CAST(video_share_count AS INTEGER), 0) AS video_share_count,
        COALESCE(TRY_CAST(video_download_count AS INTEGER), 0) AS video_download_count,
        COALESCE(TRY_CAST(video_comment_count AS INTEGER), 0) AS video_comment_count
  FROM {{ source('main', 'tiktok_dataset') }}
)

SELECT
  video_id,
  video_duration_sec,
  video_transcription_text,
  verified_status,
  author_ban_status,
  video_view_count,
  video_like_count,
  video_share_count,
  video_download_count,
  video_comment_count
FROM base