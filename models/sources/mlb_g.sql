with mlb as (
    select
        *
    from {{ source('main', 'mlb_g') }}
)

select * from mlb