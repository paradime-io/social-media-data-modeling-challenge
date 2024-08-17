-- stg_world_cities_countries.sql

with final as (
    select distinct
        -- Strings
        {{ dbt_utils.generate_surrogate_key(['c.city_name_original', 'c.country_name']) }} as unique_key,
        c.city_name_original,
        c.city_name_latin,
        c.country_name,
        c.country_code,
        c.population as city_population

    from {{ ref('world_cities_countries') }} as c
    left join
       {{ ref('common_english_words') }} sw
    on
        lower(c.city_name_latin) = lower(sw.word)
    where
        sw.word is null
)

select *
from final