with base as (
    select
        id as video_id,
        text as caption,
        to_timestamp(createTime) as created_at,
        webVideoUrl as web_video_url,
        videoUrl as video_url,
        videoUrlNoWaterMark as video_url_no_watermark,
        diggCount as likes_count,
        shareCount as shares_count,
        playCount as play_count,
        commentCount as comment_count,
        downloaded as is_downloaded,
        "authorMeta.id" as author_id,
        "authorMeta.secUid" as author_sec_uid,
        "authorMeta.name" as author_name,
        "authorMeta.nickName" as author_nickname,
        "authorMeta.verified" as author_verified,
        "authorMeta.signature" as author_signature,
        "authorMeta.avatar" as author_avatar_url,
        "musicMeta.musicId" as music_id,
        "musicMeta.musicName" as music_name,
        "musicMeta.musicAuthor" as music_author,
        "musicMeta.musicOriginal" as is_music_original,
        "musicMeta.playUrl" as music_play_url,
        "musicMeta.coverThumb" as music_cover_thumb_url,
        "musicMeta.coverMedium" as music_cover_medium_url,
        "musicMeta.coverLarge" as music_cover_large_url,
        "covers.default" as cover_default_url,
        "covers.origin" as cover_origin_url,
        "covers.dynamic" as cover_dynamic_url,
        "videoMeta.height" as video_height,
        "videoMeta.width" as video_width,
        "videoMeta.duration" as video_duration
    from 
        {{ source('raw_data', 'tiktok_videos') }}
)

select * from base