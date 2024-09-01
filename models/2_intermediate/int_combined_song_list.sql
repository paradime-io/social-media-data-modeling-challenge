with combined as (
    select *
    from {{ ref('stg_spotify_songs') }} as a

    union
     
    select
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
    from {{ ref('stg_tiktok_songs_on_spotify') }} as b
), 

sort_by_track as (
    select 
        *
        , row_number() over (partition by track_name, track_artist order by track_name, track_artist desc) as row_number
    from combined
),

deduped as ( 
    -- removing duplicates attribute data
    select
        dbt_utils.surrogate_key(['track_name', 'track_artist']) as track_id
        , track_name
        , track_artist
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
    from sort_by_track
    where
        rn = 1
    group by all

)

select *
from deduped