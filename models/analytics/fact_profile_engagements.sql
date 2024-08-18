-- fact_profile_engagements

with final as (
    select 
        {{ dbt_utils.generate_surrogate_key(['profile_id', 'category' ]) }} as unique_key,
        profile_id,
        username,
        bio,
        category,
        followers_count,
        is_business_account,
        case 
            when followers_count <= 1000 THEN 'Micro (<= 1K)'
            when followers_count <= 10000 THEN 'Small (1K - 10K)'
            when followers_count <= 100000 THEN 'Medium (10K - 100K)'
            else 'Large (> 100K)'
        end as follower_tier,
        avg(likes_count) as avg_likes,
        avg(comments_count) as avg_comments,
        avg(total_post_engagement) as total_profile_engagement,
        count(distinct post_id) as total_post_count
    from 
        {{ ref('int_instagrammable_destinations') }}
    group by 1, 2, 3, 4, 5, 6, 7
)

select * from final