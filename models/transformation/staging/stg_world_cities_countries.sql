-- stg_world_cities_countries.sql
{{
  config(
    materialized = 'view',
    database = 'transformation'
  )
}}

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
    -- remove common english words from the city list 
        left join
            {{ ref('common_english_words') }} as sw
            on
                lower(c.city_name_latin) = lower(sw.word)
    where
        sw.word is null
)

select *
from final
