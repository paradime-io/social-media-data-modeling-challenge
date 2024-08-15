{{ 
    config(materialized = 'table') 
}}

with base as (
select *
from {{ ref('yt_metric_definition') }}
),

country_dedupe as (

select *, row_number() over (partition by video_id, snapshot_date order by view_count desc nulls last) as country_dedupe
from base
)

select * exclude(country_dedupe)
from
(select *, row_number() over (partition by video_id order by snapshot_date desc nulls last) as trending_date_dedupe
from country_dedupe
where country_dedupe = 1)
--  where trending_date_dedupe = 1