with

covid_subreddit_comments_agg as (
    select *
    from {{ ref('sentiment_score_by_date') }}
),

covid_key_dates as (
    select *
    from {{ ref('covid_key_dates') }}
),

joined as (
    select distinct
        covid_subreddit_comments_agg.date,
        covid_key_dates.eventtitle as event_name,
        covid_subreddit_comments_agg.total_sentiment_score
    from covid_subreddit_comments_agg
    left join
        covid_key_dates
        on covid_subreddit_comments_agg.date between covid_key_dates.date and date_add(
                covid_key_dates.date, interval 1 day
            )
),

final as (
    select
        date,
        event_name,
        total_sentiment_score
    from joined
)

select * from final
