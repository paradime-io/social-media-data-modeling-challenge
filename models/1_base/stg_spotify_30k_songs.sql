with source as (
    select distinct
        track_name
        , track_artist
        , playlist_genre as genre
        , playlist_subgenre as subgenre
        , danceability
        , energy
        , key
        , loudness
        , mode
        , speechiness
        , acousticness
        , instrumentalness
        , liveness
        , valence
        , tempo
        , duration_ms
    from {{ source('source', 'spotify_30k_songs') }} 
)

select *
from source