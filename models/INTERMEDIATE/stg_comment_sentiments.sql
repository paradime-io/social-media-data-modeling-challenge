SELECT 
    post_id,
    comment_id,
    sentiment_score
FROM 
    {{ source('dbt_paradime_nancy_amandi', 'sentiment_scores') }}