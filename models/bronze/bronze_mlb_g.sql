with mlb as (
    select 
        *,
        'mlb' as appName,
        'google_play' as platformName 
    from {{source ('main', 'mlb_g') }}
)

select * from mlb