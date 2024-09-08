SELECT
    profile_id,
    username,
    bio,
    is_business_account,
    num_following,
    num_followers,
    num_posts,
FROM {{ ref('stg_instagram') }}
QUALIFY ROW_NUMBER() OVER (PARTITION BY profile_id ORDER BY post_date DESC) = 1