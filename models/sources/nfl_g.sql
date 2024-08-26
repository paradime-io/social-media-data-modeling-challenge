with nfl as (
    select
        *
    from {{ source('main', 'nfl_g') }}
)

select * from nfl