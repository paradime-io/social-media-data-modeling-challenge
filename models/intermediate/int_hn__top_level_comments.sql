{{
        config(
            materialized='table'
        )
}}

with
recursive parents as (
    select
        -- preserve base case id
        hn_comments.id as top_level_comment_id,
        hn_comments.parent_story_id,
        hn_comments.id,
        hn_comments.parent_id,
        hn_comments.level
    from {{ ref('stg_hn__comments') }} as hn_comments
    -- base case: is a top-level comment
    where hn_comments.level = 0
    union all
    select
        parents.top_level_comment_id,
        parents.parent_story_id,
        hn_comments.id,
        hn_comments.parent_id,
        hn_comments.level
    from
        {{ ref('stg_hn__comments') }} as hn_comments
    inner join parents on hn_comments.parent_id = parents.id
)

select
    top_level_comment_id,
    max(parent_story_id) as parent_story_id,
    count(*) as num_children
from parents
group by
    top_level_comment_id
