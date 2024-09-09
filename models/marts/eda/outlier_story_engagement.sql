select *
from {{ ref('int_hn__stories_engagement' ) }}
where points > all(select upper_fence_points from {{ ref('int_hn__stories_outliers') }})
and num_comments > all(select upper_fence_comments from {{ ref('int_hn__stories_outliers') }})