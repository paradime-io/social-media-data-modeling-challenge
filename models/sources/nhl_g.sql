with nhl as (
    select 
        *,
        'nhl' as appName
    from {{ source('main', 'nhl_g') }}
)

select * from nhl