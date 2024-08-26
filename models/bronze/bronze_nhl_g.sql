with nhl as (
    select 
        *,
        'nhl' as appName,
        'google_play' as platformName
    from {{source ('main', 'nhl_g') }}
)

select * from nhl