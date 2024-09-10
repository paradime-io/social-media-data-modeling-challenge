WITH spotify_tracks AS (
    SELECT 
        track_id,
        track_name,
        id_artists,
        artists,
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
    FROM 
        {{ ref('stg_spotify_tracks') }}
),

spotify_artists_original AS (
    SELECT 
        spotify_artist_id,
        artist_name
    FROM 
        {{ ref('stg_spotify_artists_original') }}
),

spotify_artists AS (
    SELECT 
        id,
        name,
        genres
    FROM 
        {{ ref('stg_spotify_artists') }}
),

final AS (
    SELECT 
        track.track_id,
        track.track_name,
        COALESCE(artist_ori.artist_name, artist.name) AS artist_name,
        artist.genres,
        track.popularity, 
        track.danceability, 
        track.energy, 
        track.loudness, 
        track.speechiness, 
        track.acousticness, 
        track.instrumentalness, 
        track.liveness, 
        track.positiveness, 
        track.tempo, 
        track.beats_per_bar
    FROM  
        spotify_tracks track 
    LEFT JOIN 
        spotify_artists_original artist_ori 
        ON artist_ori.spotify_artist_id = track.id_artists
    LEFT JOIN 
        spotify_artists artist 
        ON artist.id = artist_ori.spotify_artist_id
        OR LOWER(artist.name) = LOWER(artist_ori.artist_name)
        OR LOWER(artist.name) = LOWER(track.artists)
        OR artist.name ilike '%' || track.artists || '%'
)

SELECT   
    track_id,
    track_name,
    artist_name,
    genres,
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
FROM final
