with mlb as (
    select 
        *,
        'mlb' as appName 
    from {{ref ('mlb_g') }}
)

select * from mlb