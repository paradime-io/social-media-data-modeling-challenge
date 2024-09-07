SELECT
    skibidi_topics,
    type,
    popularity
FROM {{ ref ('stg_trending_topics') }}