SELECT
  sid,
  profile_id,
  username,
  bio,
  date::date AS post_date,
  date::time AS post_time,
  IF(post_type = 1, 'Photo', 'Video') AS post_type,
  description,
  likes AS num_likes,
  comments AS num_comments,
  following AS num_following,
  followers AS num_followers,
  num_posts,
  is_business_account,
  description_category
FROM {{ source('main', 'instagram_posts') }}