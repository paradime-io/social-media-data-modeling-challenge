WITH spotify_tracks_ori AS (
    SELECT 
        spotify_track_id,
        artists_ids,
        isrc
    FROM {{ ref('stg_spotify_tracks_original') }}
),

spotify_tracks AS (
    SELECT 
        track_id,
        track_name
    FROM {{ ref('stg_spotify_tracks') }}
),

spotify_artists_original AS (
    SELECT 
        spotify_artist_id,
        artist_name
    FROM {{ ref('stg_spotify_artists_original') }}
),

apple_music_tracks AS (
    SELECT 
        apple_music_isrc,
        artist_name AS apple_artist_name
    FROM {{ ref('stg_apple_music_tracks') }}
),

spotify_artists AS (
    SELECT 
        id,
        name,
        genres
    FROM {{ ref('stg_spotify_artists') }}
),

final AS (
    SELECT 
        track_ori.spotify_track_id AS track_id,
        COALESCE(track.track_name, artist_ori.artist_name, apple.apple_artist_name) AS track_name,
        artist.genres
    FROM spotify_tracks_ori track_ori
    LEFT JOIN spotify_tracks track 
        ON track.track_id = track_ori.spotify_track_id
    LEFT JOIN spotify_artists_original artist_ori 
        ON artist_ori.spotify_artist_id = track_ori.artists_ids
    LEFT JOIN apple_music_tracks apple 
        ON apple.apple_music_isrc = track_ori.isrc
    LEFT JOIN spotify_artists artist 
        ON artist.id = artist_ori.spotify_artist_id
        OR LOWER(artist.name) = LOWER(artist_ori.artist_name)
        OR LOWER(artist.name) = LOWER(apple.apple_artist_name)
)

SELECT * FROM final