SELECT 
    id,
    title,
    url,
    REGEXP_REPLACE(
        REGEXP_REPLACE(author, '\b(Posted|by)\b', '', 'gi'), -- Remove "Posted" and "by"
        '[^A-Za-z]', '', 'g' -- Remove bad characters
    ) AS author,
    CAST(
        STRPTIME(
            REGEXP_REPLACE(publication_date, '(on |@)', '', 'gi')  
            , '%A %B %d, %Y %I:%M%p') 
        AS TIMESTAMP) AS creation_post_date,
    comments
FROM {{ source('src_scraper_slashdot', 'src_scraper_slashdot') }}
