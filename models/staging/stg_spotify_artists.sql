
with base as (
    select
        *
    from 
        {{ source('raw_data', 'spotify_artists_2') }}
)

select * from base