with nhl as (
    select 
        *,
        'nhl' as appName 
    from {{ref ('nhl_g') }}
)

select * from nhl