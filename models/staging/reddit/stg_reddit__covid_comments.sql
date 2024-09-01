with

source as (
    select *
    from {{ source('reddit_covid', 'comments') }}
),

filtered as (
    select
        id as comment_id,
        to_timestamp(created_utc) as created_at,
        to_timestamp(created_utc)::date as created_date,
        type,
        "subreddit.id" as subreddit_id,
        "subreddit.name" as subreddit_name,
        "subreddit.nsfw" as subreddit_nsfw,
        permalink,
        body,
        sentiment,
        score
    from source
    where to_timestamp(created_utc)::date >= '2020-02-11'
)

select * from filtered
