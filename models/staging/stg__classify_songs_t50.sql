select
    t50.date as snapshot_date,
    coalesce(t50.song , tsongs.name ) as song,
    coalesce(t50.artists , tsongs.artists ) as artists,
    t50.artists,
    t50.position,
    t50.popularity,
    country.country_code,
    tsongs.danceability,
    tsongs.energy,
    tsongs.key,
    tsongs.loudness,
    tsongs.mode,
    tsongs.speechiness,
    tsongs.acousticness,
    tsongs.instrumentalness,
    tsongs.liveness,
    tsongs.valence,
    tsongs.tempo,
    'spotify_top_50_playlists' as source
from {{ ref('base_spotify_top_50_playlists') }} as t50
left join {{ ref('base_countries') }} as country
    on lower(t50.country) = lower(country.country_name)
left join {{ ref('base_universal_top_spotify_songs') }} as tsongs
    on (t50.song, t50.artists) = (tsongs.name, tsongs.artists)

