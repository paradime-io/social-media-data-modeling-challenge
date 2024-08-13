-- int_instagrammable_countries.sql
with insta_post_data as (
    select * from {{ ref('stg_instagram_data') }} 
    where category in ('travel_&_adventure', 'food_&_dining')
),

insta_countries as(
    select distinct
         -- IDs
        ipd.post_id,

        -- Strings
        case 
            -- if post mentions a country in desciption column, get that directly from the mention itself
            when countries.post_id is not null then countries.country_name_mentioned
            --there is no country mentioned but a city mentioned, drive the country from where the city is
            when countries.post_id is null and cities.post_id is not null then cities.country_name_derived
            else null
        end as country_mentioned,
        cities.city_name_mentioned as city_mentioned,
        ipd.language,
        ipd.category,
        ipd.description,
        ipd.comments,

        -- Numerics
        ipd.likes_count,
        ipd.comments_count,
        ipd.following_count,
        ipd.followers_count,
        ipd.post_count,
    
        -- Booleans
        ipd.is_business_account,

        -- Dates
        ipd.post_date   
    from insta_post_data as ipd
        left join {{ ref('int_country_mentions') }} as countries
        on ipd.post_id = countries.post_id
        left join {{ ref('int_city_mentions') }} as cities
        on ipd.post_id = cities.post_id
    
)

select * from insta_countries