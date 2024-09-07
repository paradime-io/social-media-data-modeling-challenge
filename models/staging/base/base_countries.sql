with source as (
    select * from {{ ref('countries') }}
),

rename as (
    select
        name as country_name,
        "alpha-2" as country_code,
        region as country_region,
        "sub-region" as country_sub_region
    from source
)

select * from rename
