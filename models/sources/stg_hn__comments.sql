select
    id,
    author,
    children,
    created_at,
    parent_id,
    parent_story_id,
    story_id,
    text,
    level,
    date_trunc('day', created_at)::date as created_at_date
from {{ source('raw_data', 'comments') }}
where created_at_date <= '2024-07-26'::date
