WITH spotify_apple AS (
    SELECT 
        track_id, 
        track_name
    FROM {{ ref('int_spotify_apple_joined') }}
),

genres AS (
    SELECT 
        track_id, 
        generalized_genre
    FROM {{ ref('int_genres_generalised') }}
),

additional_spotify_metrics AS (
    SELECT 
       track_id, 
       popularity, 
       danceability, 
       energy, 
       loudness, 
       speechiness, 
       acousticness, 
       instrumentalness, 
       liveness, 
       positiveness, 
       tempo, 
       beats_per_bar
    FROM {{ ref('stg_spotify_tracks') }}
)

SELECT 
    sa.track_id,
    sa.track_name,
    g.generalized_genre AS genres,
    asm.popularity,
    asm.danceability,
    asm.energy,
    asm.loudness,
    asm.speechiness,
    asm.acousticness,
    asm.instrumentalness,
    asm.liveness,
    asm.positiveness,
    asm.tempo,
    asm.beats_per_bar
FROM spotify_apple sa
LEFT JOIN genres g ON sa.track_id = g.track_id
LEFT JOIN additional_spotify_metrics asm ON sa.track_id = asm.track_id