-- stg_twitter_data.sql

with final as (
    select
        -- IDs
        id as twitter_data_id,
        user_id,

        -- Strings
        user_name,
        tweet_content,

        -- Numerics
        favourite_count,

        -- Dates
        case 
            when created_at = 'None' or created_at is null then null
            else strftime(strptime(created_at, '%a %b %d %H:%M:%S %z %Y'), '%Y-%m-%d')
        end as tweet_date,
        
        -- Timestamps
        scraped_at

    from {{ source('main', 'twitter_data') }}
)

select *
from final