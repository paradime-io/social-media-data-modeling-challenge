with base as (
    select * from {{ ref('fct_tiktok_music_joined_features')}}
),

correlation_matrix as (
    {% set tiktok_metrics = [
        'total_play_count',
        'total_likes_count',
        'total_shares_count',
        'total_comment_count'
    ] %}
    
    {% set music_metrics = [
        'popularity_quartile',
        'genre_value',
        'intensity_quartile',
        'rhythm_quartile',
        'sound_type_quartile',
        'liveness_quartile',
        'beats_per_bar_quartile'
    ] %}

    {% for tiktok_metric in tiktok_metrics %}
    SELECT
        '{{ tiktok_metric }}' as tiktok_metric
        {% for music_metric in music_metrics %}
        , {{ corr(tiktok_metric, music_metric, 'base') }} as {{ music_metric }}_corr
        {% endfor %}
    FROM base
    {% if not loop.last %}
    UNION ALL
    {% endif %}
    {% endfor %}
)

select distinct * from correlation_matrix
