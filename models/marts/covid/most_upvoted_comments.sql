{{ config(
    materialized="view",
) }}

with

covid_subreddit_comments as (
    select *
    from {{ ref('stg_reddit__covid_comments_in_covid_subreddit') }}
),

covid_comments_ranked as (
    select
        comment_id,
        created_date,
        body,
        sentiment,
        score
    from covid_subreddit_comments
    order by score desc
    limit 10
),

final as (
    select
        comment_id,
        created_date,
        body,
        sentiment,
        score
    from covid_comments_ranked
)

select * from final
