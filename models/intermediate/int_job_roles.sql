-- Aggregated job roles & average compensation from survey takers
-- on Kaggle and Stack Overflow
with job_roles as (
  select 
      job_role
      ,yearly_comp_usd
    from {{ ref('int_stackoverflow_roles') }}
  
  union all 
  select 
      job_role
      ,yearly_comp_usd
    from {{ ref('int_kaggle_roles') }}
)

, clean_comp as (
  select
    trim(lower(job_role)) as job_role
    ,yearly_comp_usd
    ,regexp_extract(yearly_comp_usd, '^(.*?)-', 1) as comp_low
    ,regexp_extract(yearly_comp_usd, '-(.*)$', 1) as comp_high
  from (
    select
      job_role
      ,regexp_replace(yearly_comp_usd, '[>,]+', '', 'g') as yearly_comp_usd
    from job_roles
  )
)


, comp_mid as (
  select 
    regexp_extract(job_role, '^[^,]+') as job_role -- Keep only first selected option
    ,yearly_comp_usd
    ,case 
      when ((comp_low != '') and (comp_high != '')) then ((comp_high::int + comp_low::int) / 2)::decimal
      else yearly_comp_usd::decimal
    end as yearly_comp_mid
  from clean_comp
  where 
    job_role not in ('none', '')
    and job_role is not null
)

select 
  {{ clean_job_roles('job_role') }} as job_role
  ,round(avg(yearly_comp_mid),2) as avg_yearly_comp
from comp_mid
group by 1