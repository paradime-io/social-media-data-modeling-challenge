with song_list as (
    select
        *
    from {{ ref('int_combined_song_list') }}
)

select *
from song_list