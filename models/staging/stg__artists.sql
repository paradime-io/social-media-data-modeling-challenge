select distinct tsongs.artists
from {{ ref('base_universal_top_spotify_songs') }} as tsongs
union
select distinct t50.artists
from {{ ref('base_spotify_top_50_playlists') }} as t50
