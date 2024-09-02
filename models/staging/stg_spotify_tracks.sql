with base as (
    select
       id as track_id, 
       name as track_name, 
       popularity, 
       duration_ms / 1000 as duration_seconds,
       REPLACE(REPLACE(REPLACE(artists, '[', ''), ']', ''), '''', '') AS artists,
       REPLACE(REPLACE(REPLACE(id_artists, '[', ''), ']', ''), '''', '') AS id_artists,
       release_date, 
       danceability, 
       energy, 
       loudness, 
       speechiness, 
       acousticness, 
       instrumentalness, 
       liveness, 
       valence as positivness, 
       tempo, 
       time_signature as beats_per_bar
     from 
        {{ source('raw_data', 'spotify_tracks_2') }} t1 
    
)

select * from base
