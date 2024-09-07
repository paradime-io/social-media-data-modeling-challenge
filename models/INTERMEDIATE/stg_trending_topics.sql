WITH trending_topics AS (
SELECT 
    "TOP Related Topics (skibidi) (8/1/20 - 8/13/24)" as skibidi_topics,
    popularity,
    'Top Related Topics' as type
FROM 
    {{ source('dbt_paradime_nancy_amandi', 'TrendingTopics') }}
    ),
trending_topics2 AS (
SELECT 
    "Top Topics (skibidi) 8/1/20 - 8/13/24" as skibidi_topics,
    popularity,
    'Top Topics' as type
FROM 
    {{ source('dbt_paradime_nancy_amandi', 'relatedEntities') }}
    )
SELECT * FROM trending_topics
UNION ALL
SELECT * FROM trending_topics2