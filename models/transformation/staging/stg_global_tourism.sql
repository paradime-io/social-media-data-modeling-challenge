-- stg_global_tourism.sql

with final as (
    select
        -- Strings
        entity as country_name,
        code as country_iso_code,

        -- Numerics
        "International tourism, number of arrivals" as international_arrivals,

        -- Dates
        year

    from {{ ref('global_tourism_data') }}
)

select *
from final