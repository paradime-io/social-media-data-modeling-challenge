select
    *,
    round(max_comment_depth
    / (case when num_comments > 0 then num_comments else 1 end), 2) as stir_score
from {{ ref('int_hn__stories_engagement' ) }}
where points
    > all(select upper_fence_points from {{ ref('int_hn__stories_outliers') }})
    and num_comments
    > all(
        select upper_fence_comments from {{ ref('int_hn__stories_outliers') }}
    )
