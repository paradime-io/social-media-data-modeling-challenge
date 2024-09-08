WITH user_metrics AS (
    SELECT
        username,
        bio,
        is_business_account,
        num_following,
        num_followers,
        num_posts
    FROM {{ ref('int_instagram_latest_user_metrics') }}
),

post_engagement AS (
    SELECT
        sid,
        num_likes,
        num_comments
        engagement_level,
        total_engagement
    FROM {{ ref('int_instagram_post_engagement') }}
),

post_summary AS (
    SELECT
        sid,
        post_date,
        LENGTH(description) AS description_length,
        EXTRACT(DOW FROM post_date) AS post_day_of_week,
        EXTRACT(HOUR FROM post_time) AS post_hour_of_day
    FROM {{ ref('int_instagram_post_summary') }}
)

SELECT
    um.username,
    um.bio,
    um.is_business_account,
    um.num_following,
    um.num_followers,
    um.num_posts,
    COUNT(pe.sid) AS total_posts,
    AVG(pe.total_engagement) AS avg_engagement,
    MAX(pe.total_engagement) AS max_engagement,
    MIN(pe.total_engagement) AS min_engagement,
    AVG(ps.description_length) AS avg_description_length,
    AVG(ps.post_day_of_week) AS avg_post_day_of_week,
    AVG(ps.post_hour_of_day) AS avg_post_hour_of_day
FROM user_metrics um
LEFT JOIN post_engagement pe ON um.profile_id = pe.sid
LEFT JOIN post_summary ps ON pe.sid = ps.sid
GROUP BY um.username, um.bio, um.is_business_account, um.num_following, um.num_followers, um.num_posts
