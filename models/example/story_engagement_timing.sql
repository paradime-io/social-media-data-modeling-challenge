with avg_engagement as (
    select
        avg(score) as avg_score,
        avg(descendants) as avg_comments
    from {{ source('hn', 'hacker_news') }}
    where type = 'story'
)

select
    h.timestamp,
    ((h.score - e.avg_score) / e.avg_score)
    + ((h.descendants - e.avg_comments) / e.avg_comments) as engagement_score
from {{ source('hn', 'hacker_news') }} as h
inner join avg_engagement as e
    on h.type = 'story'
