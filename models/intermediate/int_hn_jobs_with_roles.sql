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
    p.id
    ,p.post_year
    ,p.post_month
    ,lower(p.title) as title
    ,lower(p.text) as text
  from {{ ref('stg_hackernews') }} p
  where ((post_type = 'job'))
)

, posts_w_keywords as (
    select
    p.id
    ,k.job_role
    ,p.title
    ,row_number() over (partition by p.id, k.job_role) as rn
    from posts p
    -- Check if keyword is in title. Remove all spaces and punctuation to maximize match
    left join keywords_to_match k
    on position(regexp_replace(k.job_role, '[- ]+', '', 'g') in regexp_replace(p.title, '[- ]+', '', 'g')) > 0 
    where k.job_role is not null
)

, ranked_jobs as (
  select 
    id 
    ,job_role
    ,rank() over (partition by id order by {{ consolidate_job_roles('job_role') }} ) as job_rank
    ,title
  from posts_w_keywords
  where rn = 1 -- Ensure there's no repeated id/keyword combo
)

, found_jobs as (
  select
    r.id
    ,r.title
    ,r.job_role 
    ,{{ get_job_experience_level('p.title') }} as experience_level
    ,post_year 
    ,post_month
  from ranked_jobs r
  join posts p 
  using (id)
  where job_rank = 1
)

select 
  id
  ,title
  ,{{ clean_job_roles('job_role') }} as job_role
  ,experience_level
  ,post_year 
  ,post_month
from found_jobs 
order by 1, 3