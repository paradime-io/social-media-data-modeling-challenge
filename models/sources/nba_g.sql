with nba as (
    select 
        *
    from {{ source('main', 'nba_g') }}
)

select * from nba