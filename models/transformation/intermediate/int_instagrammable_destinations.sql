-- int_instagrammable_destinations.sql
with insta_post_data as (
    select * from {{ ref('stg_instagram_data') }}
    where category in ('travel_&_adventure', 'food_&_dining')
),

insta_countries as (
    select distinct
        ipd.*,
        cities.city_name_mentioned as city_mentioned,
        case
            -- if post mentions a country in desciption column, get that directly from the mention itself
            when
                countries.post_id is not null
                then countries.country_name_mentioned
            -- if there is no country mentioned but a city mentioned, drive the country from where the city is
            when
                countries.post_id is null and cities.post_id is not null
                then cities.country_name_derived
        end as country_mentioned
    from insta_post_data as ipd
    left join {{ ref('int_country_mentions') }} as countries
        on ipd.post_id = countries.post_id
    left join {{ ref('int_city_mentions') }} as cities
        on ipd.post_id = cities.post_id
),

final as (
    select
        -- IDs
        {{ dbt_utils.generate_surrogate_key(['ic.post_id', 'ic.country_mentioned','ic.city_mentioned' ]) }} as unique_key,
        ic.profile_id,
        ic.post_id,

        -- Strings
        ic.username,
        ic.bio,
        ic.country_mentioned,
        ic.city_mentioned,
        ic.language,
        ic.category,
        ic.description,
        ic.comments,

        -- Numerics
        ic.likes_count,
        ic.comments_count,
        ic.following_count,
        ic.followers_count,
        ic.post_count,
        gt.international_arrivals,
        ic.likes_count + ic.comments_count as total_post_engagement,

        -- Booleans
        ic.is_business_account,

        -- Dates
        ic.post_date
    from insta_countries as ic
    left join {{ ref('stg_global_tourism') }} as gt
        on lower(ic.country_mentioned) = lower(gt.country_name)
            and extract(year from ic.post_date) = gt.year
)

select * from final
