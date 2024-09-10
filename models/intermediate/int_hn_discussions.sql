{{ config(materialized='view') }}

SELECT
    hn.id,
    hn.created_at,
    hn.author,
    hn.type,
    hn.title,
    hn.text,
    hn.url,
    hn.score,
    hn.parent,
    REGEXP_EXTRACT(hn.url, 'https://github.com/([^/]+/[^/]+)') AS mentioned_repo,
    st.sentiment,
    st.main_topic AS topic,   -- Main topic
    st.sub_topic              -- Sub topic
FROM {{ ref('stg_hacker_news') }} hn
LEFT JOIN {{ ref('stg_hn_sentiment_topics') }} st ON hn.id = st.id
