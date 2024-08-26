with nfl as (
    select 
        *,
        'nfl' as appName 
    from {{source ('main','nfl_g') }}
)

select * from nfl