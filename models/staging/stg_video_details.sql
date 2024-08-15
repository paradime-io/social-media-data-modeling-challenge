{{ 
    config(materialized = 'table') 
}}

with video_details as (
select *
from {{ source('source', 'video_details') }}
)

select *, 
        (
         coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)D', 1), '') AS INT) * 86400), 0) + 
         coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)H', 1), '') AS INT) * 3600), 0) + 
         coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)M', 1), '') AS INT) * 60), 0) + 
         coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)S', 1), '') AS INT)), 0)
        ) as total_seconds,
       cast(coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)D', 1), '') AS INT) * 86400), 0) + 
            coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)H', 1), '') AS INT) * 3600), 0) + 
            coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)M', 1), '') AS INT) * 60), 0) + 
            coalesce((CAST(NULLIF(regexp_extract(duration, '([0-9]+)S', 1), '') AS INT)), 0) as int
           )/60 as total_minutes
from video_details



