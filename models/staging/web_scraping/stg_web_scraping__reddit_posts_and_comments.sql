with
    source as (
        select
            id
            , subreddit
            , __type as type
            , lower(text) as text
            , sentiment
        from {{ source('web_scraping', 'reddit_posts_and_comments') }}
    )

select distinct *
from source