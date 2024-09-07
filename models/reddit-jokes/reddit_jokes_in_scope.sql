SELECT
    type,
    id,
    subid,
    subname,
    subnsfw,
    created_utc,
    permalink,
    domain,
    url,
    selftext,
    title,
    score
FROM
   -- analytics.reddit_jokes
    {{ source('reddit_jokes', 'reddit_jokes') }} 
WHERE
    id IN (
        SELECT id FROM  {{ source('reddit_jokes', 'jokes_features') }} 
        INTERSECT
        SELECT id FROM {{ source('reddit_jokes', 'jokes_sn') }} 
    )