with custom_roles as (
  select array['ai engineer'
              ,'ai scientist'
              ,'data analyst'
              ,'data science product manager'
              ,'dev ops'
              ,'business analyst'
              ,'engineer'
              ,'marketing analyst'
              ,'web developer'
              ,'financial analyst'
              ,'frontend'
              ,'fullstack'
              ,'ios'
              ,'mobile'
              ,'machine learning specialist'
              ,'machine learning engineer'
              ,'machine learning research engineer'
              ,'ml engineer'
              ,'ml scientist'
              ,'mlops'
              ,'platform engineer'
              ,'product engineer'
              ,'product design'
              ,'project manager'
              ,'qa engineer'
              ,'quantitative analyst'
              ,'teacher'
              ,'professor'
  ] as job_array
)
                
, keywords_to_match as (
  -- Join with custom roles to maximize retreival of job postings
  select 
    unnest(job_array) as job_role 
  from custom_roles

  union all

  select
    job_role 
  from {{ ref('int_job_roles') }}
)

, posts as (
  select
    job_id
    ,listed_job_role
    ,job_title as job_description
    ,experience_level
    ,post_year 
    ,post_month 
    ,yearly_comp_usd
    ,job_skills 
    ,job_type_skills
  from {{ ref('stg_linkedin_jobs') }} 
)

, posts_w_keywords as (
    select
		  p.job_id
      ,p.listed_job_role
      ,k.job_role
	    ,row_number() over (partition by p.job_id, k.job_role) as rn
    from posts p
    -- Check if keyword is in job_role. Remove all spaces and punctuation to maximize match
    left join keywords_to_match k
    on position(regexp_replace(k.job_role, '[- ]+', '', 'g') in regexp_replace(p.listed_job_role, '[- ]+', '', 'g')) > 0 
    where k.job_role is not null
)

, ranked_jobs as (
  select 
    *
    ,rank() over (partition by listed_job_role order by {{ consolidate_job_roles('job_role') }} ) as job_rank
  from posts_w_keywords
  where rn = 1 -- Ensure there's no repeated id/keyword combo
)

, found_jobs as (
  select
    r.job_id
    ,r.listed_job_role
    ,r.job_role
    ,job_description
    ,experience_level
    ,post_year 
    ,post_month 
    ,yearly_comp_usd
    ,job_skills 
    ,job_type_skills
  from ranked_jobs r
  join posts p 
  using (job_id)
  where job_rank = 1
)

select 
    job_id
    ,listed_job_role
    ,job_role
    ,job_description
    ,experience_level
    ,post_year 
    ,post_month 
    ,yearly_comp_usd
    ,job_skills
from found_jobs 
order by 1