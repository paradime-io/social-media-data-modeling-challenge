SELECT 
    id,
    "subreddit.id" AS subreddit_id,
    "subreddit.name" AS subreddit_name,
    "subreddit.nsfw" AS is_nsfw_subreddit,
    TO_TIMESTAMP(created_utc) AS created_timestamp,
    type,
    permalink,
    selftext AS text,
    title,
    score
FROM {{ source('main', 'reddit_jokes') }}
