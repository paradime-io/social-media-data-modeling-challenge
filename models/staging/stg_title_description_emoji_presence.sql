{{ 
    config(materialized = 'table') 
}}

with title_description_emoji_presence as (
select *
from {{ source('supporting_data', 'title_description_emoji_presence') }}
)

select *
from title_description_emoji_presence



