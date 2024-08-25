-- stg_instagram_data.sql

with final as (
    select
        -- IDs
        post_id,
        sid,
        sid_profile as sid_profile_id,
        profile_id,

        -- Strings
        post_type,
        lang as language,
        category,
        description,
        comments,
        username,
        bio,

        -- Numerics
        likes as likes_count,
        comments as comments_count,
        following as following_count,
        followers as followers_count,
        num_posts as post_count,
    
        -- Booleans
        is_business_account,

        -- Dates
        date::date as post_date

    from {{ source('main', 'instagram_data') }}
)

select *
from final
