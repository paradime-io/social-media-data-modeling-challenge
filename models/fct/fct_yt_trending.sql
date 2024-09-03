WITH prep_yt_trending AS (
    SELECT
    *
    FROM {{ ref('prep_yt_trending') }}
)
, dim_category_snapshot AS (
    SELECT
        dim_yt_category_sk,
        category_id,
        country_code,
        dbt_valid_from,
        coalesce(dbt_valid_to, valid_to) AS category_valid_to --- dbt_valid_to is null when line is still valid
    FROM {{ ref('category_snapshot') }}
)
, dim_channel_snapshot AS (
    SELECT
        dim_yt_channel_sk,
        channel_id,
        dbt_valid_from,
        coalesce(dbt_valid_to, valid_to) AS channel_valid_to --- dbt_valid_to is null when line is still valid
    FROM {{ ref('channel_snapshot') }}
)
, dim_country AS (
    SELECT
    *
    FROM {{ ref('dim_country') }}
)
, add_keys AS (
    SELECT
        --Primary Key
        prep_yt_trending.fct_yt_trending_sk,
        --Natural Key
        prep_yt_trending.video_id,
        --Foreign Keys
        dim_category_snapshot.dim_yt_category_sk,
        dim_channel_snapshot.dim_yt_channel_sk,
        dim_country.dim_yt_country_sk,
        prep_yt_trending.trending_snapshot_date_sk,
        --Attributes
        prep_yt_trending.video_title,
        prep_yt_trending.video_publication_timestamp,
        prep_yt_trending.video_tags,
        prep_yt_trending.view_count,
        prep_yt_trending.likes,
        prep_yt_trending.comment_count,
        prep_yt_trending.thumbnail_link,
        prep_yt_trending.comments_disabled,
        prep_yt_trending.ratings_disabled,
        prep_yt_trending.video_description,
        get_current_timestamp() as etl_timestamp
    FROM prep_yt_trending
    LEFT OUTER JOIN dim_category_snapshot
        ON prep_yt_trending.category_id = dim_category_snapshot.category_id
        AND prep_yt_trending.country_code = dim_category_snapshot.country_code
        AND (prep_yt_trending.trending_date >= dim_category_snapshot.dbt_valid_from
        AND prep_yt_trending.trending_date < dim_category_snapshot.category_valid_to)
    LEFT OUTER JOIN dim_channel_snapshot
        ON prep_yt_trending.channel_id = dim_channel_snapshot.channel_id
        AND (prep_yt_trending.trending_date >= dim_channel_snapshot.dbt_valid_from 
        AND prep_yt_trending.trending_date < dim_channel_snapshot.channel_valid_to)
    LEFT OUTER JOIN dim_country
        ON prep_yt_trending.country_code = dim_country.country_code
)
SELECT
       --Primary Key
       fct_yt_trending_sk,
        --Natural Key
        video_id,
        --Foreign Keys
        dim_yt_category_sk,
        dim_yt_channel_sk,
        dim_yt_country_sk,
        trending_snapshot_date_sk,
        --Attributes
        video_title,
        video_publication_timestamp,
        video_tags,
        view_count,
        likes,
        comment_count,
        thumbnail_link,
        comments_disabled,
        ratings_disabled,
        video_description,
        etl_timestamp
FROM add_keys
