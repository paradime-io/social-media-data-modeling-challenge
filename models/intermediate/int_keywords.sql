select distinct keywords 
from (
    select ml_keywords as keywords 
    from {{ ref('int_ml_keywords') }}

    union all 

    select programming_languages as keywords 
    from {{ ref('int_programming_language_keywords') }}

    union all 

    select distinct job_role as keywords
    from {{ ref('int_job_roles') }}

    union all 

    select job_skills as keywords
    from {{ ref('int_linkedin_job_skills') }}
)
where keywords not in ('other', 'na', 'none', 'unknown')