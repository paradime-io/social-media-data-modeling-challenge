with

covid_subreddit_comments as (
    select *
    from {{ ref('stg_reddit__covid_comments_in_covid_subreddit') }}
),

aggregated as (
    select
        created_date AS date,
        sum(sentiment) as total_sentiment_score
    from covid_subreddit_comments
    group by created_date
),

final as (
    select
        date,
        total_sentiment_score
    from aggregated
)

select * from final
