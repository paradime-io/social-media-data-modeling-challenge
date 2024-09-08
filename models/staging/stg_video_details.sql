{{ 
    config(materialized = 'table') 
}}

with video_details as (
    select *
    from {{ source('supporting_data', 'video_details') }}
)

select
    video_id,
    category_id,
    caption,
    (
        coalesce((cast(nullif(regexp_extract(duration, '([0-9]+)D', 1), '') as int) * 86400), 0)
        + coalesce((cast(nullif(regexp_extract(duration, '([0-9]+)H', 1), '') as int) * 3600), 0)
        + coalesce((cast(nullif(regexp_extract(duration, '([0-9]+)M', 1), '') as int) * 60), 0)
        + coalesce((cast(nullif(regexp_extract(duration, '([0-9]+)S', 1), '') as int)), 0)
    ) / 60 as total_minutes
from video_details
