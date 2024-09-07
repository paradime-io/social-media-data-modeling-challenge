SELECT
    normalized_value,
    type,
    sentiment_tone,nsfw,
    COUNT(*) AS occurrence,
    AVG(sentiment_magnitude) AS avg_sentiment
FROM
   --dbt_tathagatyash.reddit_jokes_topic_with_sn
    {{ ref('reddit_jokes_topic_with_sn') }}
GROUP BY
    normalized_value,
    type,
    sentiment_tone,nsfw
ORDER BY
    occurrence DESC