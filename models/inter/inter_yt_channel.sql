WITH stg_yt_trending AS (
    SELECT 
    channelId,
    channelTitle
    FROM {{ ref('stg_yt_trending') }}
),
    distinct_yt_channel AS (
        SELECT distinct
        channelId as channel_id,
        channelTitle as channel_title 
        FROM 
        stg_yt_trending
    )
SELECT 
channel_id,
channel_title
FROM distinct_yt_channel