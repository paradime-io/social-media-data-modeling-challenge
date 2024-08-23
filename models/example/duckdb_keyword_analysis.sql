select
    year(timestamp) as year,
    month(timestamp) as month,
    by as username,
    count(*) as keyword_mentions
from {{ source('hn', 'hacker_news') }}
where
    (title like '%duckdb%' or text like '%duckdb%')
group by all
order by year asc, month asc
