with jobs as (
  select
    trim(lower(job_title_short)) as listed_job_role
    ,trim(lower(job_title)) as job_title
    ,lpad(extract(year from job_posted_date)::varchar, 4, '0') as post_year
    ,lpad(extract(month from job_posted_date)::varchar, 2, '0') as post_month
    ,case 
      when lower(salary_rate) like 'hour' and salary_hour_avg is not null then salary_hour_avg * 2080 
      else salary_year_avg
    end as yearly_comp_usd
    ,job_skills 
    ,job_type_skills
  from {{ source('jobs', 'lbarousse_data') }}
  where 
    lower(job_via) like '%linkedin%'
    and job_posted_date >= '2022-01-01'
    and job_posted_date < '2023-12-01' -- Stop at Nov 2023
    and lower(search_location) like '%united states%'
)

select 
  row_number() over() as job_id
  ,listed_job_role
  ,job_title
  ,{{ get_job_experience_level('job_title') }} as experience_level
  ,post_year
  ,post_month 
  ,yearly_comp_usd
  ,job_skills 
  ,job_type_skills
from jobs