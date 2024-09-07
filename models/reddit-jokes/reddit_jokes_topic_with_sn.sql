SELECT
    LOWER(value) AS normalized_value,
    type,
    sentiment_tone, sentiment_magnitude,nsfw
FROM
    {{ source('reddit_jokes', 'jokes_features') }}  f , {{ source('reddit_jokes', 'jokes_sn') }}  sn
where f.id=sn.id