with filtered_insta_data as (
    select
        post_id,
        unnest(string_to_array(lower(description), ' ')) as word
    from
        {{ ref('stg_instagram_data') }}
    where
        category in ('travel_&_adventure', 'food_&_dining')

),
-- Filter out words that are in the stop words list

matched_cities as (
    select
        i.post_id,
        c.city_name_latin as city_name_mentioned,
        c.city_population,
        c.country_name as country_name_derived,
        c.country_code as country_code_derived
    from
        filtered_insta_data i
    inner join
        {{ ref('stg_world_cities_countries') }} c
    on
        i.word = '#' || lower(c.city_name_latin) -- Match city name as-is
)
select *
from matched_cities


