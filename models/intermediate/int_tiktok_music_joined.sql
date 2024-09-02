with tiktok as (
    select * from {{ ref('stg_tiktok_videos') }}
),

music as (
    select * from {{ ref('stg_music_tracks') }}
),

spotify as (
    select * from {{ ref('stg_spotify_tracks_original') }}
)

select
    tiktok.music_id,
    music.artist_name,
    music.track_title,
    music.album_name,
    music.music_length, 
    spotify.spotify_popularity,
    count(distinct tiktok.video_id) as number_of_videos, 
    sum(tiktok.likes_count) as total_likes_count,
    sum(tiktok.shares_count) as total_shares_count,
    sum(tiktok.comment_count) as total_comment_count,
    sum(tiktok.play_count) as total_play_count
from tiktok
left join music on tiktok.music_id = music.music_id
left join spotify on music.spotify_track_id = spotify.spotify_track_id
{{ group_by (6) }}
order by 8 desc
