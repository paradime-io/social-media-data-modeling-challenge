with mlb as (
    select
        *,
        'mbl' as appName
    from {{ source('main', 'mlb_g') }}
)

select * from mlb