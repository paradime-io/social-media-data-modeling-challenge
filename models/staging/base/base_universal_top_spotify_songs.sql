with source as (
    select *
    from {{ source('challenge', 'universal_top_spotify_songs') }}
),

rename as (
    select
        spotify_id,
        name,
        artists,
        daily_rank,
        daily_movement,
        weekly_movement,
        country,
        snapshot_date,
        popularity,
        is_explicit,
        duration_ms,
        album_name,
        album_release_date,
        danceability,
        energy,
        key,
        loudness,
        mode,
        speechiness,
        acousticness,
        instrumentalness,
        liveness,
        valence,
        tempo,
        time_signature,
        split(split(filename, '/')[-1], '.')[1] as sourcefile
    from source
)

select * from rename
