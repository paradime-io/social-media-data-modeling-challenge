select 
  job_role
  ,case 
    when (job_skills like '%python%') and (job_skills like '%rust%') then 'both'
    when (job_skills like '%python%') and (job_skills not like '%rust%') then 'python'
    when (job_skills not like '%python%') and (job_skills like '%rust%') then 'rust'
    else 'other'
  end as job_skill
  ,count(job_id) as n_posts
from {{ ref('int_linkedin_roles') }}
where (job_skills like '%rust%' or job_skills like '%python%')
and job_role in ('software engineer', 'engineer')
group by 1,2