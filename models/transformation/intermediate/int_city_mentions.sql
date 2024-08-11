-- int_city_mentions.sql
with final as (
    select
        i.post_id,
        c.city_name_latin as city_name_mentioned,
        c.city_population,
        c.country_name as country_name_derived,
        c.country_code as country_code_derived
    from
        {{ ref('stg_instagram_data') }} as i
    inner join
        {{ ref('stg_world_cities_countries') }} as c
        on
            lower(i.description) like '%' || lower(c.city_name_original) || '%'
    union all
    select
        i.post_id,
        c.city_name_latin as city_name_mentioned,
        c.city_population,
        c.country_name as country_name_derived,
        c.country_code as country_code_derived
    from
        {{ ref('stg_instagram_data') }} as i
    inner join
        {{ ref('stg_world_cities_countries') }} as c
        on
            lower(i.description) like '%' || lower(c.city_name_latin) || '%'
    order by
        i.post_id
)

select *
from final
