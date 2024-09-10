WITH tiktok AS (
    SELECT
        DISTINCT 
        video_id,
        music_id,
        likes_count,
        shares_count,
        comment_count,
        play_count
    FROM
        {{ ref('stg_tiktok_videos') }}
),

music AS (
    SELECT
        DISTINCT 
        music.music_id,
        tracks.artists AS artist_name,
        COALESCE(music.spotify_track_id, tracks.track_id) AS track_id,
        tracks.track_name,
        genre.genres,
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
    FROM
        {{ ref('stg_music_tracks') }} AS music
    LEFT JOIN
        {{ ref('stg_spotify_tracks') }} AS tracks 
            ON tracks.track_id = music.spotify_track_id
    LEFT JOIN {{ ref('int_genres_generalised') }} genre
        ON genre.track_id = tracks.track_id 
),

-- Move the NTILE window functions to a subquery
music_with_quartiles AS (
    SELECT  
        DISTINCT 
        music.music_id,
        music.artist_name,
        music.track_id,
        music.track_name,
        music.genres,
        music.danceability,
        music.energy,
        music.loudness,
        music.speechiness,
        music.acousticness,
        music.instrumentalness,
        music.positiveness,
        music.tempo,
        
        (music.energy + (music.loudness + 60) / 60) / 2 AS intensity, 
        
        -- Composite Feature: Rhythm (combining danceability, positiveness, and tempo)
        (music.danceability * 0.4 + music.positiveness * 0.4 + (music.tempo / 200) * 0.2) AS rhythm,

        -- Composite Feature: Sound Type (combining acousticness, instrumentalness, and speechiness)
        (music.acousticness * 0.4 + music.instrumentalness * 0.4 + music.speechiness * 0.2) AS sound_type,

        music.popularity,
        music.liveness,
        music.beats_per_bar,

        -- quartiles
        NTILE(4) OVER (ORDER BY music.popularity) AS popularity_quartile,
        NTILE(4) OVER (ORDER BY intensity) AS intensity_quartile,
        NTILE(4) OVER (ORDER BY rhythm) AS rhythm_quartile,
        NTILE(4) OVER (ORDER BY sound_type) AS sound_type_quartile,
        NTILE(4) OVER (ORDER BY music.liveness) AS liveness_quartile,
        NTILE(4) OVER (ORDER BY music.beats_per_bar) AS beats_per_bar_quartile
    FROM music
),

genres_continous AS (
    SELECT  
        genres, 
        row_number() OVER (ORDER BY genres) genre_value
    FROM music_with_quartiles
    WHERE genres IS NOT NULL
    GROUP BY 1
),

final AS (
    SELECT
        DISTINCT
        tiktok.music_id,
        music_with_quartiles.artist_name,
        music_with_quartiles.track_id,
        music_with_quartiles.track_name,
        gc.genres,
        gc.genre_value,
        music_with_quartiles.intensity,
        music_with_quartiles.rhythm,
        music_with_quartiles.sound_type,
        music_with_quartiles.popularity,
        music_with_quartiles.liveness,
        music_with_quartiles.beats_per_bar,
        music_with_quartiles.danceability,
        music_with_quartiles.energy,
        music_with_quartiles.loudness,
        music_with_quartiles.speechiness,
        music_with_quartiles.acousticness,
        music_with_quartiles.instrumentalness,
        music_with_quartiles.positiveness,
        music_with_quartiles.tempo,
        music_with_quartiles.popularity_quartile,
        music_with_quartiles.intensity_quartile,
        music_with_quartiles.rhythm_quartile,
        music_with_quartiles.sound_type_quartile,
        music_with_quartiles.liveness_quartile,
        music_with_quartiles.beats_per_bar_quartile,

        -- Aggregate metrics
        COUNT(DISTINCT tiktok.video_id) AS number_of_videos,
        SUM(tiktok.likes_count) AS total_likes_count,
        SUM(tiktok.shares_count) AS total_shares_count,
        SUM(tiktok.comment_count) AS total_comment_count,
        SUM(tiktok.play_count) AS total_play_count
    FROM tiktok
    LEFT JOIN music_with_quartiles 
        ON tiktok.music_id = music_with_quartiles.music_id
    INNER JOIN genres_continous gc 
        ON gc.genres = music_with_quartiles.genres
    GROUP BY 
        {{ group_by(26) }}
)

SELECT * FROM final
