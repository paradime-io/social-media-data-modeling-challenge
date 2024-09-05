with base as (
    select
        video_id,
        video_height,
        video_width,
        video_duration,
        sum(play_count) as total_play_count,
        sum(likes_count) as total_likes_count,
        sum(shares_count) as total_shares_count,
        sum(comment_count) as total_comment_count
    from
        {{ ref('stg_tiktok_videos') }}
    group by video_id, video_height, video_width, video_duration
),

correlation_matrix as (
    {% set viral_metrics = [
        'total_play_count',
        'total_likes_count',
        'total_shares_count',
        'total_comment_count'
    ] %}
    {% set video_specs = [
        'video_height',
        'video_width',
        'video_duration'
    ] %}

    {% for spec in video_specs %}
        select
            '{{ spec }}' as video_spec
            {% for metric in viral_metrics %}
                , {{ corr(spec, metric, 'base') }} as {{ metric }}_corr
                {% endfor %}
        from base
        {% if not loop.last %}
            union all
        {% endif %}
    {% endfor %}
)

select distinct *
from correlation_matrix
