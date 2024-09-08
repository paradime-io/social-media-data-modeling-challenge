{{ 
    config(materialized = 'table') 
}}

with country_cpm_rates as (
select *
from {{ ref('country_cpm_rates') }}
)

select country as country_id,
       cpm as country_cpm_rate
from country_cpm_rates



