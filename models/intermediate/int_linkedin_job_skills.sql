with jobs as (
  select 
    regexp_replace(unnest(string_to_array(job_skills, ',')), '[''\]\[]+', '', 'g') as job_skills
  from {{ ref('int_linkedin_roles') }} 
)

, plural_keywords as (
  select job_skills 
  from jobs
  where job_skills like '%s'
  and substring(job_skills, 1, length(job_skills)-1) in (select job_skills from jobs)
)

, clean_keywords as (
    select 
    case 
        when job_skills like 'go%' then 'golang'
        else job_skills
    end as job_skills

    from (
        select rpad(job_skills, cast(length(job_skills)+1 as integer), ' ') as job_skills
        from (
            select 
            distinct trim(lower(job_skills)) as job_skills
            from jobs
        where 
        job_skills not in (select job_skills from plural_keywords)
        and lower(job_skills) not in ('na', 'other', 'none', '', 'no / none', 'nan')
        and lower(job_skills) is not null)
    )
)

select distinct job_skills
from clean_keywords

order by 1 asc