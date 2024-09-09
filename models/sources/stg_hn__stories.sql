select
    id,
    created_at,
    updated_at,
    author,
    points,
    title,
    url,
    story_text,
    date_trunc('day', created_at)::date as created_at_date,
    coalesce (story_text is not null, false) as is_text_post
from {{ source('raw_data', 'stories') }}
where created_at_date <= '2024-07-26'::date