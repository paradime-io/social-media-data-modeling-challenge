-- stg_world_cities_countries.sql

with final as (
    select
        -- Strings
        city_name_original,
        city_name_latin,
        country_name,
        country_code,
        population as city_population

    from {{ ref('world_cities_countries') }}
)

select *
from final