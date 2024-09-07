select
    tsongs.snapshot_date,
    tsongs.name as song,
    tsongs.artists,
    tsongs.daily_rank as position,
    tsongs.popularity,
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
    'universal_top_spotify_songs' as source
from {{ ref('base_universal_top_spotify_songs') }} as tsongs
left join {{ ref('base_countries') }} as country
    on tsongs.country = country.country_code