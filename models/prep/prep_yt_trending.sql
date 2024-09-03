WITH stg_yt_trending AS (
    SELECT
    *
    FROM {{ref('stg_yt_trending')}}
), dim_date AS (
    SELECT
    *
    FROM {{ ref('dim_date') }}
)
, add_keys AS (
    SELECT 
        {{dbt_utils.generate_surrogate_key(['video_id','country','trending_date'])}} AS fct_yt_trending_sk,
        video_id,
        title AS video_title,
        publishedAt AS video_publication_timestamp,
        channelId AS channel_id,
        channelTitle AS channel_title,
        categoryId AS category_id,
        country AS country_code,
        CAST(trending_date AS DATE) as trending_date,
        CAST(dim_date.dim_date_sk  AS INT) AS trending_snapshot_date_sk,
        tags as video_tags,
        view_count,
        likes,
        comment_count,
        thumbnail_link,
        comments_disabled,
        ratings_disabled,
        description as video_description
    FROM stg_yt_trending
    LEFT OUTER JOIN dim_date
        ON stg_yt_trending.trending_date = dim_date.full_date
)
SELECT
    fct_yt_trending_sk,
    video_id,
    video_title,
    video_publication_timestamp,
    channel_id,
    channel_title,
    category_id,
    country_code,
    trending_date,
    trending_snapshot_date_sk,
    video_tags,
    view_count,
    likes,
    comment_count,
    thumbnail_link,
    comments_disabled,
    ratings_disabled,
    video_description
FROM add_keys