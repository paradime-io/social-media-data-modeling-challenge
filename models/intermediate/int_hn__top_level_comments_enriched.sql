select
    stories.*,
    top_level_comments.*
from {{ ref('int_hn__top_level_comments') }} as top_level_comments
left join
    {{ ref('stg_hn__stories') }} as stories
    on top_level_comments.parent_story_id = stories.id
