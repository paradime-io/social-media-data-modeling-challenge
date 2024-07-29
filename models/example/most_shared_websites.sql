SELECT
    regexp_extract(url, 'http[s]?://([^/]+)/', 1) AS domain,
    count(*) AS count

FROM {{ source('hn', 'hacker_news') }} 
WHERE url IS NOT NULL AND regexp_extract(url, 'http[s]?://([^/]+)/', 1) != ''
GROUP BY domain
ORDER BY count DESC