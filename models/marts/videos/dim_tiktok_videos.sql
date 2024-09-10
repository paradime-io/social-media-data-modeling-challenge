with base as (
    select
        video_id,
        music_id,
        caption,
        created_at,
        likes_count,
        shares_count,
        play_count,
        comment_count,
        is_downloaded,
        author_name,
        author_nickname,
        author_verified,
        author_signature,
        video_height,
        video_width,
        video_duration
    from {{ ref('stg_tiktok_videos') }}

)

select * from base
  
