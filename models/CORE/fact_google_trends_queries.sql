SELECT 
    "TOP Search Formats" as top_formats,
    popularity as relative_popularity,
    "Rising search formats" as rising_queries,
    popularity_1 as popularity
FROM
    {{ source('dbt_paradime_nancy_amandi', 'relatedQueries') }}