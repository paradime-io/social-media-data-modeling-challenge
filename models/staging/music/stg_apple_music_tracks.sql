with base as (
    select
        DISTINCT 
        isrc as apple_music_isrc,
        artistName as artist_name,
        name as track_name,
        albumName as album_name,
        discNumber as disc_number,
        trackNumber as track_number,
        durationInMillis as duration_ms,
        releaseDate as release_date,
        genreNames as genre_names,
        url as apple_music_url,
        "artwork.url" as artwork_url,
        "playParams.id" as play_params_id,
        "playParams.kind" as play_params_kind
    from 
        {{ source('raw_data', 'apple_music_tracks') }}
)

select * from base
