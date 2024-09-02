
with base as (
    select
        id as spotify_artist_id,
        name as artist_name,
        uri as spotify_artist_uri,
        href as spotify_artist_href,
        external_urls as spotify_artist_url -- Keeping it as a whole string or JSON object for now
    from 
        {{ source('raw_data', 'spotify_artists') }}
)

select * from base