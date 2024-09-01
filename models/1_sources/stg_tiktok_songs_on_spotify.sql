with source as (
    select distinct
        track_name
        , artist_name as track_artist
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
        , year
        , source
    from {{ source('main', 'tiktok_songs_spotify') }} 
)

select
*
from source