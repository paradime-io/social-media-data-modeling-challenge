SELECT 
    music_id,
    music_id,
    artist_name,
    track_title,
    album_name,
    music_length, 
    spotify_popularity
    
    
FROM {{ ref('stg_spotify_tracks_original ')}} ori
--left join {{ ref('stg_spotify_tracks') }} track 
  --  on track.id = ori.spotify_track_id