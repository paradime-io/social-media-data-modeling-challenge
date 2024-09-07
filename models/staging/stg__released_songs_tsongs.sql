select
    tsongs.spotify_id,
    tsongs.name as song ,
    tsongs.artists,
    tsongs.album_release_date as song_release_date,
    tsongs.album_name,
from {{ ref('base_spotify_top_50_playlists') }} as t50
left join {{ ref('base_universal_top_spotify_songs') }} as tsongs
    on (t50.song, t50.artists) = (tsongs.name, tsongs.artists)
--where tsongs.spotify_id is null
group by all
