with mlb as (
    select 
        *,
        'mlb' as appName 
    from {{source ('main', 'mlb_g') }}
)

select * from mlb