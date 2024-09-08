SELECT
    profile_id,
    username,
    bio,
    is_business_account,
    COALESCE(num_following, 0) AS num_following,
    COALESCE(num_followers, 0) AS num_followers,
    COALESCE(num_posts, 0) AS num_posts
FROM {{ ref('stg_instagram') }}
QUALIFY ROW_NUMBER() OVER (PARTITION BY profile_id ORDER BY post_date DESC) = 1