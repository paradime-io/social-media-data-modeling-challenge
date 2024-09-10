with comment_count as (
    select
        parent_story_id,
        count(*) as num_comments
    from {{ ref('stg_hn__comments') }}
    group by parent_story_id
),

top_level_comment_count as (
    select
        parent_story_id,
        max(num_children) as num_children
    from {{ ref('int_hn__top_level_comments') }}
    group by parent_story_id
)

select
    stories.id,
    stories.points,
    stories.title,
    coalesce(comment_count.num_comments, 0) as num_comments,
    coalesce(top_level_comment_count.num_children, 0)
        as max_comment_depth,
    dense_rank()
        over (order by stories.points desc, stories.id desc)
        as rank_points,
    dense_rank()
        over (
            order by
                coalesce(comment_count.num_comments, 0) desc, stories.id desc
        )
        as rank_num_comments,
    dense_rank()
        over (
            order by
                coalesce(top_level_comment_count.num_children, 0) desc,
                stories.id desc
        )
        as rank_max_comment_depth
from {{ ref('stg_hn__stories') }} as stories
left join comment_count on stories.id = comment_count.parent_story_id
left join top_level_comment_count
    on stories.id = top_level_comment_count.parent_story_id
