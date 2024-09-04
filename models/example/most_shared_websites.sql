select
    regexp_extract(url, 'http[s]?://([^/]+)/', 1) as domain,
    count(*) as count

from {{ source('hn', 'hacker_news') }}
where url is not null and regexp_extract(url, 'http[s]?://([^/]+)/', 1) != ''
group by domain
order by count desc
