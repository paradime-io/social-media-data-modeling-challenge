-- Aggregated job roles from survey takers
-- on Kaggle and Stack Overflow
with job_roles as (
  select 
      trim(lower(job_role)) as job_role
    from {{ ref('int_stackoverflow_roles') }}
  
  union all 
  select 
      trim(lower(job_role)) as job_role
    from {{ ref('int_kaggle_roles') }}
)

, clean_comp as (
  select
    {{ clean_job_roles('job_role') }} as job_role
  from job_roles
)
select 
  distinct job_role
from clean_comp
where 
    job_role not in ('none', '')
    and job_role is not null