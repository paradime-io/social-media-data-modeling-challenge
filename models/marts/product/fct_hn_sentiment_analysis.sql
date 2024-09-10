{{ config(materialized='table') }}

SELECT
    created_at::date AS analysis_date,
    main_topic,
    sub_topic,
    AVG(sentiment) AS avg_sentiment,
    COUNT(*) AS mention_count
FROM {{ ref('fct_hn_github_mentions') }}
GROUP BY 1, 2, 3