select 
  job_role
  ,count(job_id) as n_posts
from {{ ref('int_linkedin_roles') }}
group by 1
order by 2 desc 