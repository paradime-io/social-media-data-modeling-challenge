select
    year(timestamp) as year,
    month(timestamp) as month,
    count(*) as keyword_mentions
from {{ source('hn', 'hacker_news') }}
where
    (title like '%duckdb%' or text like '%duckdb%')
group by year, month
order by year asc, month asc
