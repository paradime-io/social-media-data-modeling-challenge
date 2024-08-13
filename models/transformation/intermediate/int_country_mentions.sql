-- int_country_mentions.sql

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

matched_countries as (
    select
        i.post_id,
        c.country_name as country_name_mentioned
    from
        filtered_insta_data i
    inner join
        {{ ref('stg_world_cities_countries') }} c
    on
        i.word = '#' || lower(c.country_name) -- Match country
)
select *
from matched_countries


