select {{ outlier_upper_fence('points') }} as upper_fence_points,
{{ outlier_upper_fence('num_comments') }} as upper_fence_comments,
{{ outlier_upper_fence('max_comment_depth' )}} as upper_fence_comment_depth
from {{ ref('int_hn__stories_engagement') }}