with

covid_comments as (
    select *
    from {{ ref('stg_reddit__covid_comments') }}
),

covid_comments_filtered as (
    select
        comment_id,
        created_date,
        body,
        sentiment,
        score
    from covid_comments
    where subreddit_name = 'coronavirus'
        and sentiment is not null
),

final as (
    select
        comment_id,
        created_date,
        body,
        sentiment,
        score
    from covid_comments_filtered
)

select * from final
