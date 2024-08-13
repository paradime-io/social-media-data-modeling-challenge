-- stg_common_english_words.sql

with final as (
    select
        -- Strings  
        word
    from {{ ref('common_english_words') }}
)

select *
from final