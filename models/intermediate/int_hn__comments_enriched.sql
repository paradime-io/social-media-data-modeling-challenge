select
    stories.id as story_id,
    stories.created_at_date as story_created_at_date,
    stories.author as story_author,
    stories.points as story_points,
    stories.title as story_title,
    stories.url as story_url,
    stories.story_text as story_text,
    comments.* exclude (story_id)
from {{ ref('stg_hn__comments') }} as comments
right join {{ ref('stg_hn__stories') }} as stories
on comments.parent_story_id = stories.id