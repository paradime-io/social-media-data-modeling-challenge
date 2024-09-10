select
    hn_id,
    created_at,
    text_category,
    text_subcategory,
    id,
    text_value,
    date_trunc('day', created_at)::date as created_at_date
from {{ source('raw_data', 'entity_text') }}
