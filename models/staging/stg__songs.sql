select distinct
    spotify_id,
    song,
    artists,
    release_date
from {{ ref('stg__classify_songs_t50') }} as t50
group by all
UNION
select distinct
    spotify_id,
    song,
    artists,
    release_date
from {{ ref('stg__classify_songs_tsongs') }} as tsongs
