SELECT 
    regexp_extract(URL, 'http[s]?://([^/]+)/', 1) AS domain,
    count(*) AS count

FROM {{ source('main', 'hn') }} 
group by domain