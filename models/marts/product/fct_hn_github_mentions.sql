{{ config(materialized='table') }}

SELECT
    hn.id,
    hn.created_at,
    hn.author,
    hn.title,
    hn.text,
    hn.url,
    hn.score,
    st.sentiment,
    st.main_topic,
    st.sub_topic
FROM {{ ref('stg_hacker_news') }} hn
LEFT JOIN {{ ref('stg_hn_sentiment_topics') }} st ON hn.id = st.id