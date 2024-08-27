WITH videos AS (
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
  FROM {{ ref('stg_videos') }}
),

video_claims AS (
  SELECT
      video_id,
      claim_status
  FROM {{ ref('stg_video_claims') }}
)

SELECT
  v.video_id,
  v.video_duration_sec,
  v.video_transcription_text,
  v.verified_status,
  v.author_ban_status,
  vc.claim_status,
  v.video_view_count,
  v.video_like_count,
  v.video_share_count,
  v.video_download_count,
  v.video_comment_count
FROM videos v
LEFT JOIN video_claims vc ON v.video_id = vc.video_id
