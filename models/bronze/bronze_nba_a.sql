with nba as (
    select 
        *,
        'nba' as appName,
        'app_store' as platformName 
    from {{source ('main', 'nba_a') }}
)

select * from nba