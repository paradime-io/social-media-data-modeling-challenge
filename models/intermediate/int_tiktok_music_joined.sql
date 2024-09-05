with tiktok as (
    select
        video_id,
        music_id,
        likes_count,
        shares_count,
        comment_count,
        play_count
    from
        {{ ref('stg_tiktok_videos') }}
),

music as (
    select
        music.music_id,
        tracks.artists as artist_name,
        coalesce(tracks.track_id, music.spotify_track_id) as track_id,
        tracks.track_name,
        genres.generalized_genre AS genres,
        tracks.popularity,
        tracks.danceability,
        tracks.energy,
        tracks.loudness,
        tracks.speechiness,
        tracks.acousticness,
        tracks.instrumentalness,
        tracks.liveness,
        tracks.positiveness,
        tracks.tempo,
        tracks.beats_per_bar
    from
        {{ ref('stg_music_tracks') }} as music
    left join
        {{ ref('stg_spotify_tracks') }} as tracks 
            on tracks.track_id = music.spotify_track_id
    left join {{ ref('int_genres_generalised')}} genres 
        on genres.track_id = tracks.track_id 
),

final as (
    select
        DISTINCT
        tiktok.music_id,
        music.artist_name,
        music.track_id,
        music.track_name,
        music.genres,
        music.popularity,
        music.danceability,
        music.energy,
        music.loudness,
        music.speechiness,
        music.acousticness,
        music.instrumentalness,
        music.liveness,
        music.positiveness,
        music.tempo,
        music.beats_per_bar,
        count(distinct tiktok.video_id) as number_of_videos,
        sum(tiktok.likes_count) as total_likes_count,
        sum(tiktok.shares_count) as total_shares_count,
        sum(tiktok.comment_count) as total_comment_count,
        sum(tiktok.play_count) as total_play_count
    from tiktok
    left join music on tiktok.music_id = music.music_id
    {{ group_by(16) }}
)

SELECT music_id, COUNT(*) FROM final
group by 1 order by 2 desc