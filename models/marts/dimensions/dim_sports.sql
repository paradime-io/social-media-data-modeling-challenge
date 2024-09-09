with
    staging as (
        select
            id
            , name
        from {{ ref('stg_olympics_api__sports') }}
    )

select *
from staging