select distinct
    spotify_id,
    song,
    artists,
from {{ ref('stg__released_songs_t50') }} as t50
group by all
UNION
select distinct
    spotify_id,
    song,
    artists,
from {{ ref('stg__released_songs_tsongs') }} as tsongs
