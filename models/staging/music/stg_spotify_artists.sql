
with base as (
    select
        id, 
        followers, 
        genres, 
        name, 
        popularity
    from 
        {{ source('raw_data', 'spotify_artists_2') }}
)

select * from base