{{ config(
    materialized='table'
) }}

WITH post_engagement AS (
    SELECT
        sid,
        num_likes,
        num_comments,
        engagement_level,
        total_engagement
    FROM {{ ref('int_instagram_post_engagement') }}
),

post_summary AS (
    SELECT
        sid,
        post_date,
        post_time,
        description_length,
        description_category,
        post_day_of_week,
        post_hour_of_day
    FROM {{ ref('int_instagram_post_summary') }}
),

hashtags AS (
    SELECT
        sid,
        hashtag
    FROM {{ ref('int_instagram_hashtags') }} AS hashtag
)

SELECT
    ps.sid,
    num_likes,
    num_comments,
    engagement_level,
    total_engagement,
    post_date,
    post_time,
    description_length,
    description_category,
    post_day_of_week,
    post_hour_of_day,
    COUNT(DISTINCT hashtag) AS distinct_hashtag_count
FROM post_summary AS ps
LEFT JOIN post_engagement AS pe
    ON pe.sid = ps.sid
LEFT JOIN hashtags AS hash
    ON hash.sid = ps.sid
GROUP BY
    ps.sid,
    num_likes,
    num_comments,
    engagement_level,
    total_engagement,
    post_date,
    post_time,
    description_length,
    description_category,
    post_day_of_week,
    post_hour_of_day