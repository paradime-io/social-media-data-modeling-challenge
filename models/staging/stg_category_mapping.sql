{{ 
    config(materialized = 'table') 
}}

with category_mapping as (
select *
from {{ ref('category_mapping') }}
)

select *
from category_mapping



