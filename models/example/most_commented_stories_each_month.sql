with ranked_stories as (
    select
        title,
        descendants as nb_comments,
        'https://news.ycombinator.com/item?id=' || id as hn_url,
        year(timestamp) as year,
        month(timestamp) as month,
        row_number()
            over (
                partition by year(timestamp), month(timestamp)
                order by descendants desc
            )
            as rn
    from {{ source('hn', 'hacker_news') }}
    where type = 'story'
)

select
    year,
    month,
    title,
    hn_url,
    nb_comments
from ranked_stories
where rn = 1
order by year, month
