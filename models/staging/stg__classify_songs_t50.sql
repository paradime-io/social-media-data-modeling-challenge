select
    tsongs.spotify_id,
    t50.date as snapshot_date,
    coalesce(t50.song , tsongs.name ) as song,
    coalesce(t50.artists , tsongs.artists ) as artists,
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
    case when try_cast(t50.release_date as date) is null then try_cast(tsongs.album_release_date as date) else try_cast(release_date as date) end  as release_date,
    'spotify_top_50_playlists' as source
from {{ ref('base_spotify_top_50_playlists') }} as t50
left join {{ ref('base_countries') }} as country
    on lower(t50.country) = lower(country.country_name)
left join {{ ref('base_universal_top_spotify_songs') }} as tsongs
    on (t50.song, t50.artists) = (tsongs.name, tsongs.artists)

