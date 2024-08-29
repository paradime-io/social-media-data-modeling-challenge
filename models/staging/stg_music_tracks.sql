with base as (
    select
        id as music_id,
        artist as artist_name,
        title as track_title,
        album as album_name,
        release_date as release_date,
        label as record_label,
        timecode as music_length,
        song_link as song_link,
        "apple_music.isrc" as apple_music_isrc,
        "spotify.id" as spotify_track_id
    from 
        {{ source('raw_data', 'music_tracks') }}
)

select * from base
