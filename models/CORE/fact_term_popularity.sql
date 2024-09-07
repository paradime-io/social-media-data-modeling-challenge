SELECT 
    term,
    count,
    'comment' as reddit_type
FROM
    {{ source('dbt_paradime_nancy_amandi', 'term_counts') }}
UNION ALL
SELECT 
    term,
    count,
    'post' as reddit_type
FROM
    {{ source('dbt_paradime_nancy_amandi', 'terms_from_posts') }}
