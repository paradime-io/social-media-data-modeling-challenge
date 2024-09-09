select
    hn_id,
    created_at,
    text_category,
    text_subcategory,
    text_value,
    date_trunc('day', created_at)::date as created_at_date
from {{ source('raw_data', 'entity_text') }}
where created_at_date <= '2024-07-26'::date
