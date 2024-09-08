SELECT
    profile_id,
    username,
    bio,
    is_business_account,
    {{ group_follower_counts('num_followers') }} AS num_followers,
    {{ group_follower_counts('num_following') }} AS num_following,
    num_posts
FROM {{ ref('stg_instagram') }}
QUALIFY ROW_NUMBER() OVER (PARTITION BY profile_id ORDER BY post_date DESC) = 1