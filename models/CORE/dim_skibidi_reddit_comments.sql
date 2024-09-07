SELECT 
    DISTINCT
    reddit_comment_key,
    subreddit,
    post,
    post_url,
    post_title,
    comment_author,
    comments
FROM 
    {{ ref ('stg_reddit_comments') }}