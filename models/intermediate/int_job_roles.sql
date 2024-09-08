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

, clean_role as (
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
    case 
      when lower(job_role) like '%academic%' then 'academic'
      when (lower(job_role) like '%back%end%') then 'backend' -- Forego 'developer' for better job title matches
      when (lower(job_role) like '%front%end%') then 'frontend'
      when (lower(job_role) like '%full%stack%') then 'fullstack'
      when (lower(job_role) like '%qa%') then 'qa engineer'
      when lower(job_role) like '%engineer%data%' then 'data engineer'
      when lower(job_role) like '%scientist, data%' then 'data scientist'
      when lower(job_role) like '%data%analyst%' then 'data analyst'
      -- Data Scientist combined w ML Engineer, so to resolve mark as ML engineer bc it's reporting higher salary (src: Indeed, Glassdoor)
      when lower(job_role) like '%machine%learning%' then 'machine learning'
      when lower(job_role) like 'research%' then 'research'
      when ((lower(job_role) like '%na%') or (lower(job_role) like '%other%')) then 'other'
      else job_role
    end as job_role
    ,yearly_comp_usd
    ,case 
      when ((comp_low != '') and (comp_high != '')) then ((comp_high::int + comp_low::int) / 2)::decimal
      else yearly_comp_usd::decimal
    end as yearly_comp_mid
  from clean_role
  where 
    lower(job_role) not in ('none', '')
    and lower(job_role) is not null
)

select 
  job_role
  ,round(avg(yearly_comp_mid),2) as avg_yearly_comp
from comp_mid
group by 1
order by 1, 2 desc