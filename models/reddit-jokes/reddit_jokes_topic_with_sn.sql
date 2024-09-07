SELECT
    LOWER(value) AS normalized_value,
    type,
    sentiment_tone, sentiment_magnitude,nsfw
FROM
    jokes_features f , jokes_sn sn
where f.id=sn.id