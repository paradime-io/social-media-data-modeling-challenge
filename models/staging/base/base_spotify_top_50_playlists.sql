with source as (
    select *
    from {{ source('challenge', 'spotify_top_50_playlists') }}
),

rename as (
    select
        date,
        position,
        song,
        artist as artists,
        popularity,
        duration_ms,
        album_type,
        total_tracks,
        release_date,
        is_explicit,
        album_cover_url,
        split(split(split(filename, '/')[-1], '.')[1], '-')[-1] as country,
        split(split(filename, '/')[-1], '.')[1] as sourcefile
    from source
)

select * from rename
