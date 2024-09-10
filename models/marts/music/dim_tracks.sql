with tracks as (
    SELECT 
         music_id,
         artist_name,
         track_id,
         track_name,
         genres,
         popularity,
         loudness,
         speechiness,
         acousticness,
         instrumentalness,
         liveness,
         positiveness,
         tempo,
         beats_per_bar
    FROM {{ ref('fct_tiktok_music_joined_features') }}
),
genres as (
    SELECT 
        track_id, 
        genres
    FROM {{ ref('int_genres_generalised')}}
),

final as (
SELECT 
    DISTINCT
    tracks.track_id,
    tracks.music_id,
    genres.genres,
    tracks.artist_name,
    tracks.track_name,
    tracks.genres,
    tracks.popularity,
    tracks.loudness,
    tracks.speechiness,
    tracks.acousticness,
    tracks.instrumentalness,
    tracks.liveness,
    tracks.positiveness,
    tracks.tempo,
    tracks.beats_per_bar
FROM tracks
LEFT JOIN genres ON tracks.track_id = genres.track_id
)

select * from final