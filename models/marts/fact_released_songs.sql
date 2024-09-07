with source as (
select distinct
spotify_id,
song,
artists,
song_release_date,
album_name
from {{ ref('stg__released_songs_tsongs') }}
union
select distinct
spotify_id,
song,
artists,
song_release_date,
album_name
from {{ ref('stg__released_songs_tsongs') }})
select s.spotify_id,
songs.song_pk,
artists.artists_pk,
song_release_date,
album_name
from source s 
left join {{ ref('dim_songs') }} songs on 
s.song = songs.song and s.artists = songs.artists
left join {{ ref('dim_artists') }} artists on 
s.artists = artists.artists
group by all