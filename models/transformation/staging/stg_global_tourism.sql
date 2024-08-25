-- stg_global_tourism.sql
{{
  config(
    materialized = 'view',
    database = 'transformation'
  )
}}


with final as (
    select
        -- IDs
        {{ dbt_utils.generate_surrogate_key(['entity', 'year']) }} as unique_key,

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
