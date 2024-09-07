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
    analytics.reddit_jokes
WHERE
    id IN (
        SELECT id FROM jokes_features
        INTERSECT
        SELECT id FROM jokes_sn
    )