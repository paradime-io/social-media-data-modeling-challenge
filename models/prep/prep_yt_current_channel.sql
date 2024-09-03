WITH stg_yt_trending AS (
    SELECT DISTINCT
        channelId,
        channelTitle,
        trending_date
    FROM {{ ref('stg_yt_trending') }}
)
, latest_yt_channel AS (
    SELECT DISTINCT
        channelId,
        max(trending_date) as max_trending_date
    FROM {{ ref('stg_yt_trending') }}
    GROUP BY 
        channelId,
)
, add_keys AS (
    SELECT
        -- Surrogate Keys
        {{ dbt_utils.generate_surrogate_key(['stg_yt_trending.channelId']) }} AS dim_yt_channel_sk,
        stg_yt_trending.channelId AS channel_id,
        stg_yt_trending.channelTitle AS channel_title,
        CAST(stg_yt_trending.trending_date AS DATE) trending_date
    FROM stg_yt_trending
    INNER JOIN latest_yt_channel
        ON stg_yt_trending.channelId = latest_yt_channel.channelId
        AND stg_yt_trending.trending_date = latest_yt_channel.max_trending_date
    
)
SELECT 
    dim_yt_channel_sk,
    channel_id,
    channel_title,
    trending_date
FROM add_keys