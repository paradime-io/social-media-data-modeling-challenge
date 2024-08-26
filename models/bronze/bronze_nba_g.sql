with nba as (
    select 
        *,
        'nba' as appName 
    from {{source ('main', 'nba_g') }}
)

select * from nba