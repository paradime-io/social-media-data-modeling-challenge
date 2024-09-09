with
    source as (
        select unnest(disciplines) as discipline
        from {{ source('olympics_api', 'sports') }}
    )

    , extracting_columnns as (
        select
            discipline.code as id
            , discipline.description as name
        from source
        where discipline.isSport
    )

select *
from extracting_columnns