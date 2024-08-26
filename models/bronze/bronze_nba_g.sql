with nba as (
    select 
        *,
        'nba' as appName 
    from {{ref ('nba_g') }}
)

select * from nba