{{ config(
    materialized='table'
) }}

SELECT
    id,
    sentiment,
    main_topic,
    sub_topic
FROM {{ source('raw', 'hn_sentiment_topics') }}
