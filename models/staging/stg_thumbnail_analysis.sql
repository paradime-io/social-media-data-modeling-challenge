{{ 
    config(materialized = 'table') 
}}

with thumbnail_analysis as (
    select *
    from {{ source('supporting_data', 'thumbnail_analysis') }}
)

select *
from thumbnail_analysis
