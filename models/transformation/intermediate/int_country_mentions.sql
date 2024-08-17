-- int_country_mentions.sql

with filtered_insta_data as (
    select
        post_id,
        unnest(string_to_array(regexp_replace(lower(description), '#([a-z0-9_]+)', '# \1', 'g'), ' ')) as word
    from
        {{ ref('stg_instagram_data') }}
    where
        category in ('travel_&_adventure', 'food_&_dining')

),

world_countries as(
    select distinct
        country_name
    from {{ ref('stg_world_cities_countries') }}
),

matched_countries as (
    select distinct
        {{ dbt_utils.generate_surrogate_key(['i.post_id', 'c.country_name' ]) }} as unique_key,
        i.post_id,
        c.country_name as country_name_mentioned,
        gt.international_arrivals
    from filtered_insta_data i
    inner join world_countries c
        on i.word = lower(c.country_name) -- Match country
)
select *
from matched_countries


