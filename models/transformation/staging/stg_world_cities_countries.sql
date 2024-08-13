-- stg_world_cities_countries.sql

with final as (
    select
        -- Strings
        c.city_name_original,
        c.city_name_latin,
        c.country_name,
        c.country_code,
        c.population as city_population

    from {{ ref('world_cities_countries') }} as c
    left join
        {{ ref('stg_common_english_words') }} sw -- Assume 'word' is the column name in 'stg_word'
    on
        lower(c.city_name_latin) = lower(sw.word)
    where
        sw.word is null
)

select *
from final