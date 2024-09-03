with audio as (
    select
        *
    from {{ ref('int_audio_performance') }}
)

select *
from audio