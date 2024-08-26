with nhl as (
    select 
        *
    from {{ source('main', 'nhl_g') }}
)

select * from nhl