with base as (
    select
        music_id,
        track_title,
        artist_name,
        sum(total_play_count) as total_play_count,
        sum(total_likes_count) as total_likes_count,
        sum(total_shares_count) as total_shares_count,
        avg(spotify_popularity) as avg_spotify_popularity,
        sum(total_comment_count) AS total_comment_count
    from 
        {{ ref('int_tiktok_music_joined') }}
    group by
        music_id,
        track_title,
        artist_name
),

correlation_matrix as (
    {% set tiktok_metrics = [
        'total_play_count',
        'total_likes_count',
        'total_shares_count',
        'total_comment_count'
    ] %}
    {% set streaming_metrics = [
        'avg_spotify_popularity'
    ] %}

    {% for tiktok_metric in tiktok_metrics %}
    SELECT
         '{{ tiktok_metric }}'  as tiktok_metric
        {% for streaming_metric in streaming_metrics %}
        , {{ corr(tiktok_metric, streaming_metric, 'base') }} as {{ streaming_metric }}_corr
        {% endfor %}
    FROM base
    {% if not loop.last %}
    UNION ALL
    {% endif %}
    {% endfor %}
)

select distinct * from correlation_matrix
