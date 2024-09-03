with top_audio as (
    select
        *
    from {{ ref('int_tiktok_top_audio_cleaned') }}
)

select *
from top_audio