with base as (
    select
        id as spotify_track_id,
        name as track_name,
        popularity as spotify_popularity,
        is_playable as is_playable,
        disc_number as disc_number,
        duration_ms as duration_ms,
        explicit as is_explicit,
        "album.name" as album_name,
        "album.album_group" as album_group,
        "album.album_type" as album_type,
        "album.id" as album_id,
        "album.uri" as album_uri,
        "album.href" as album_href,
        "album.release_date" as album_release_date,
        "album.release_date_precision" as release_date_precision,
        "external_ids.isrc" as isrc,
        "external_urls.spotify" as spotify_track_url,
        artists_ids as artists_ids
    from 
        {{ source('raw_data', 'spotify_tracks') }}
)

select * from base 
