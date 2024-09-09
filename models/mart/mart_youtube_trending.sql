{{
    config(
        materialized='incremental',
        unique_key=['fct_yt_trending_sk']
    )
}}

WITH fact_trending AS (
    SELECT * FROM {{ ref('fct_yt_trending') }}
    {% if is_incremental() %}
      WHERE  etl_timestamp >= current_date - {{ var('days_to_load', 5) }}
    {% endif %}
),
dim_category AS (
    SELECT * FROM {{ ref('category_snapshot') }}
),
dim_histo_channel AS (
    SELECT * FROM {{ ref('channel_snapshot') }}
),
dim_current_channel AS (
    SELECT * FROM {{ ref('dim_current_channel')}}
),
dim_country AS (
    SELECT * FROM {{ ref('dim_country') }}
),
dim_date AS (
    SELECT * FROM {{ ref('dim_date') }}
)

SELECT 
    -- surrogate key
    fact_trending.fct_yt_trending_sk,
    -- natural keys
    fact_trending.video_id,
    dim_histo_channel.channel_id,
    -- atributes
    fact_trending.video_title,
    dim_category.category_title,
    dim_histo_channel.channel_title as histo_channel_title,
    dim_current_channel.channel_title as current_channel,
    dim_country.country_code,
    dim_country.country_desc,
    fact_trending.thumbnail_link,
    -- dates
    trending_date.full_date as trending_date,
    trending_date.month_number,
    trending_date.date_month,
    trending_date.date_quarter,
    trending_date.date_year,
    trending_date.day_of_week,
    trending_date.weekday_name,
    trending_date.is_weekend,
    --- video_publication
    video_publication_date.full_date as video_publication_date,
    fact_trending.video_publication_timestamp,
    video_publication_date.month_number,
    video_publication_date.date_month,
    video_publication_date.date_quarter,
    video_publication_date.date_year,
    video_publication_date.day_of_week,
    video_publication_date.weekday_name,
    video_publication_date.is_weekend,
    -- description
    fact_trending.video_tags,
    fact_trending.video_description,
    -- measures
    fact_trending.view_count,
    fact_trending.likes,
    fact_trending.comment_count,
    -- flag
    fact_trending.comments_disabled,
    fact_trending.ratings_disabled,
    dim_category.category_assigned
FROM fact_trending
INNER JOIN dim_category
    ON fact_trending.dim_yt_category_sk = dim_category.dbt_scd_id
INNER JOIN dim_histo_channel
    ON fact_trending.dim_yt_channel_histo_sk = dim_histo_channel.dbt_scd_id
INNER JOIN dim_current_channel 
    ON fact_trending.dim_yt_current_channel_sk = dim_current_channel.dim_yt_channel_sk
INNER JOIN dim_country
    ON fact_trending.dim_yt_country_sk = dim_country.dim_yt_country_sk
INNER JOIN dim_date as trending_date
    ON fact_trending.trending_snapshot_date_sk = trending_date.dim_date_sk
INNER JOIN dim_date as video_publication_date
    ON fact_trending.video_publication_date_sk = video_publication_date.dim_date_sk