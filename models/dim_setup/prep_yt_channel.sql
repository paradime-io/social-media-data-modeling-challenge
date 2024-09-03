WITH min_yt_channel AS (
    SELECT DISTINCT
        channelId,
        channelTitle,
        min(trending_date) as trending_date
    FROM {{ ref('stg_yt_trending') }}
    GROUP BY 
        channelId,
        channelTitle
)
, add_keys AS (
    SELECT
        -- Surrogate Keys
        {{ dbt_utils.generate_surrogate_key(['channelId']) }} AS dim_yt_channel_sk,
        channelId AS channel_id,
        channelTitle AS channel_title,
        CAST(trending_date AS DATE) trending_date
    FROM min_yt_channel
)
SELECT 
    dim_yt_channel_sk,
    channel_id,
    channel_title,
    trending_date
FROM add_keys