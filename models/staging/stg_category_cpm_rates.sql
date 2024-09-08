{{ 
    config(materialized = 'table') 
}}

with category_cpm_rates as (
select *
from {{ ref('category_cpm_rates') }}
)

select category_name, 
       cpm as category_cpm_rate
from category_cpm_rates
