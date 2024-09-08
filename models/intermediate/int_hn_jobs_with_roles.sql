with keywords_to_match as (
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
    ,p.post_year 
    ,p.post_month
    ,p.title
    ,p.text
    from posts p
    -- Check if keyword is in title. Remove all spaces and punctuation to maximize match
    left join keywords_to_match k
    on position(regexp_replace(k.job_role, '[- ]+', '', 'g') in regexp_replace(p.title, '[ ]+', '', 'g')) > 0 
    where k.job_role is not null
)

select 
  distinct id -- Ensure there's no repeated id/keyword combo
  ,job_role
  ,case 
    when ((position('junior' in lower(title)) > 0) 
			or (position('entry' in lower(title)) > 0)) then 'entry-level'
    
		when ((position('mid l' in lower(title)) > 0) 
			or (position('mid-' in lower(title)) > 0)) then 'mid-level'
    
		when ((position('senior' in lower(title)) > 0)) then 'senior'
    
		when ((position('manager' in lower(title)) > 0)
            and ((position('product manager' in lower(title)) = 0)
            or (position('project manager' in lower(title)) = 0))) then 'manager'
    else 'unknown'
  end as role_level
  ,title
  ,case 
    when position('yc' in lower(title)) = 0 then regexp_extract(title, '^(.*?) is ', 1)
    when position('yc' in lower(title)) > 0 then regexp_extract(title, '^(.*?) \(', 1) 
    else title
    end as company_hiring
  ,post_year
  ,post_month
  ,text
from posts_w_keywords
order by 1 desc, 2