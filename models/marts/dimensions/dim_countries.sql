with
    staging as (
        select
            id
            , name
            , official_name
            , continent_code
            , continent_name
            , emoji as flag
        from {{ ref('country_codes') }}
    )

select *
from staging