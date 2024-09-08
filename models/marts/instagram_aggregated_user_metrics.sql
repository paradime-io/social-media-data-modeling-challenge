{{ config(
    materialized='table'
) }}

WITH user_metrics AS (
    SELECT
        profile_id,
        username,
        is_business_account,
        num_following,
        num_followers,
        num_posts
    FROM {{ ref('int_instagram_latest_user_metrics') }}
),

post_engagement AS (
    SELECT
        sid,
        profile_id,
        num_likes,
        num_comments
        engagement_level,
        total_engagement
    FROM {{ ref('int_instagram_post_engagement') }}
),

post_summary AS (
    SELECT
        sid,
        profile_id,
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
    FROM {{ ref('int_instagram_hashtags') }}
)

SELECT
    um.profile_id,
    um.username,
    um.is_business_account,
    um.num_following,
    um.num_followers,
    um.num_posts,
    AVG(pe.total_engagement) AS avg_engagement,
    MAX(pe.total_engagement) AS max_engagement,
    MIN(pe.total_engagement) AS min_engagement,
    AVG(ps.description_length) AS avg_description_length,
    AVG(ps.post_day_of_week)::int64 AS avg_post_day_of_week,
    AVG(ps.post_hour_of_day)::int64 AS avg_post_hour_of_day,
    COUNT(DISTINCT hashtag) AS distinct_hashtag_count
FROM user_metrics um
LEFT JOIN post_engagement pe 
    ON um.profile_id = pe.sid
LEFT JOIN post_summary AS ps
    ON pe.sid = ps.sid
LEFT JOIN hashtags hash 
    ON pe.sid = hash.sid
GROUP BY 
    um.profile_id,
    um.username,
    um.is_business_account, 
    um.num_following, 
    um.num_followers, 
    um.num_posts