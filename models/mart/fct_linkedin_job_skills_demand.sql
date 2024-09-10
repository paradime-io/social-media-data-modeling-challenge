with linkedin_job_skills as (
    select 
        job_id 
        ,job_role
        ,post_year
        ,post_month
        ,regexp_replace(job_skills, '[''\]\[]+', '', 'g') as job_skills
    from (
    select 
        job_id
        ,job_role
        ,post_year
        ,post_month
        ,unnest(string_to_array(job_skills, ',')) as job_skills
    from {{ ref('int_linkedin_roles') }}  
    )
)
select 
  trim(job_skills) as job_skills 
  ,post_year
  ,post_month
  ,count(distinct job_id) as n_posts
from linkedin_job_skills
group by 1,2,3
order by 1, 4 desc