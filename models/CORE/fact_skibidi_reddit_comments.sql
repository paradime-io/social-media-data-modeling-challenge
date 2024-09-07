SELECT 
    DISTINCT
    reddit_comment_key,
    created_at as post_created_at,
    strftime('%Y%m%d', CAST("post_created_at" AS DATE)) AS post_date_id,
    comment_created_at,
    strftime('%Y%m%d', CAST("comment_created_at" AS DATE)) AS comment_date_id,
    score as post_score,
    num_comments,
    upvote_ratio,
    comment_score,
    sentiment_score
FROM 
    {{ ref ('stg_reddit_comments') }} as rc
LEFT JOIN {{ ref ('stg_comment_sentiments') }} as cs
ON rc.post_id = cs.post_id AND rc.comment_id = cs.comment_id