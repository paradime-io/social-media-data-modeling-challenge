with nfl as (
    select 
        *,
        'nfl' as appName 
    from {{ref ('nfl_g') }}
)

select * from nfl