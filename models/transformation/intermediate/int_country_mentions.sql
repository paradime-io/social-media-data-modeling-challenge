-- int_country_mentions.sql

with final as (
    select
        i.post_id,
        c.country_code as country_mentioned
    from
        {{ ref('stg_instagram_data') }} as i
    inner join
        {{ ref('stg_world_cities_countries') }} as c
        on
            lower(i.description) like '%' || lower(c.country_name) || '%'
    union all
    select
        i.post_id,
        c.country_code as country_mentioned
    from
        {{ ref('stg_instagram_data') }} as i
    inner join
        {{ ref('stg_world_cities_countries') }} as c
        on
            lower(i.description) like '%' || lower(c.country_code) || '%'
    order by
        i.post_id
)

select *
from final
