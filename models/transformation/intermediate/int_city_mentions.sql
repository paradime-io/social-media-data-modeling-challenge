-- int_city_mentions

-- Filter instagram data to only travel related posts
with filtered_insta_data as (
    select
        post_id,
        unnest(string_to_array(lower(description), ' ')) as word
    from
        {{ ref('stg_instagram_data') }}
    where
        category in ('travel_&_adventure', 'food_&_dining')

),

-- Extract city names mentioned from the post description
matched_cities as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['i.post_id', 'c.city_name_latin', 'c.country_name' ]) }} as unique_key,
        i.post_id,
        c.city_name_latin as city_name_mentioned,
        c.country_name as country_name_derived,
        c.country_code as country_code_derived
    from
        filtered_insta_data as i
        inner join
            {{ ref('stg_world_cities_countries') }} as c
            on
                i.word = '#' || lower(c.city_name_latin) -- Match city name as-is
)

select *
from matched_cities
