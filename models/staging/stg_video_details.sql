{{ 
    config(materialized = 'table') 
}}

with video_details as (
select *
from {{ source('supporting_data', 'video_details') }}
)

select video_id,
       category_id,
       caption, 
        (coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)D', 1), '') AS INT) * 86400), 0) + 
         coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)H', 1), '') AS INT) * 3600), 0) + 
         coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)M', 1), '') AS INT) * 60), 0) + 
         coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)S', 1), '') AS INT)), 0)
        )/60 as total_minutes
from video_details



