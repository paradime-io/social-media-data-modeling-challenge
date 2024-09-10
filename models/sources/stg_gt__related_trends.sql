select
    trend_name,
    trend_type,
    search_type,
    related_trend_type,
    lower(related_trend_name) as related_trend_name,
    value,
    value_pct_growth,
    index
from {{ source('raw_data', 'gt_related_trends') }}
qualify
    row_number() over (partition by
        trend_name,
        trend_type,
        related_trend_type,
        lower(related_trend_name)
    order by index) = 1
