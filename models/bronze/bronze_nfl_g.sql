with nfl as (
    select 
        *,
        'nfl' as appName,
        'google_play' as platformName
    from {{source ('main','nfl_g') }}
)

select * from nfl