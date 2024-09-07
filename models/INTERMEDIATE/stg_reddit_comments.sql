SELECT 
    {{ dbt_utils.generate_surrogate_key(['post_id', 'comment_id']) }} as reddit_comment_key,
    post_id,
    subreddit,
    TO_TIMESTAMP(created_utc) AS created_at,
    selftext as post,
    post_url,
    post_title,
    score,
    num_comments,
    upvote_ratio,
    comment_id,
    comment_author,
    comment_body as comments,
    comment_score,
    TO_TIMESTAMP(comment_created_utc) AS comment_created_at
FROM 
    {{ source('dbt_paradime_nancy_amandi', 'reddit_skibidi_toilet_comments') }}
WHERE selftext ILIKE '%skibidi' 
    OR selftext ILIKE '%skibidi%'
    OR selftext ILIKE 'skibidi%'