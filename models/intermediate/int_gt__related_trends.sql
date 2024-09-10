select
    trend_name,
    trend_type,
    related_trend_type,
    related_trend_name,
    value,
    value_pct_growth,
    row_number()
        over (
            partition by trend_name, trend_type, related_trend_type
            order by index
        )
        as rank
from {{ ref('stg_gt__related_trends') }}
