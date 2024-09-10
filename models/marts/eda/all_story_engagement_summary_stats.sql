select
    count(*)::numeric as total_stories_submitted,
    sum(num_comments)::numeric as total_comments,
    sum(points)::numeric as total_upvotes,
    median(points)::numeric as med_points,
    median(num_comments)::numeric as med_comments,
    median(max_comment_depth)::numeric as med_max_comment_depth
from {{ ref('int_hn__stories_engagement' ) }}
