-- Use after getting job roles from job postings
-- Consolidate redundant roles grouped by job IDs 
-- Input (column_name): job_role
{% macro consolidate_job_roles(column_name) %}
  case 
    -- Only need to rank them lower than jobs that commonly have prefix
    when lower({{ column_name }}) like '%backend%' then 2
    when lower({{ column_name }}) like '%software engineer%' then 3
    when lower({{ column_name }}) like 'engineer%' then 4
    when lower({{ column_name }}) like 'designer' then 4

    when lower({{ column_name }}) like 'manager' then 3
    when lower({{ column_name }}) like 'analyst' then 3

    when lower({{ column_name }}) like '%developer%' then 5
    when lower({{ column_name }}) like 'scientist%' then 4
    when lower({{ column_name }}) like 'other%' then 5
    else 1
  end
{% endmacro %}