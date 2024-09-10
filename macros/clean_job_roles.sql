-- macro to clean job roles. Each data source has their own categorization,
-- and we need a way to organize these roles at the end while retaining
-- original category. Categories to clean primarily based on custom roles, and also
-- based on Kaggle & Stack Overflow categories to keep survey data (eg compensation etc)
-- Custom roles are * for future reference
{% macro clean_job_roles(column_name) %}
  case 
    when {{ column_name }} like '%academic%' then 'academic'
    when {{ column_name }} like '%back%end%' then 'backend'
    when {{ column_name }} like '%front%end%' then 'frontend'
    when {{ column_name }} like '%full%stack%' then 'fullstack'
    when {{ column_name }} like '%ios%' then 'mobile developer' -- *
    when {{ column_name }} like 'developer, mobile%' then 'mobile developer'
    when {{ column_name }} like 'developer, desktop%' then 'desktop/enterprise app developer'
    when {{ column_name }} like 'developer, embed%' then 'embedded app developer'
    when {{ column_name }} like 'developer, game%' then 'game developer'

    when {{ column_name }} like '%qa%' then 'qa engineer'
    when {{ column_name }} like '%engineer%data%' then 'data engineer'
    when {{ column_name }} like '%engineer%site%' then 'site-reliability engineer'
    when {{ column_name }} like '%scientist, data%' then 'data scientist'
    when {{ column_name }} like '%analyst%' then 'analyst'
    -- Combining ml / machine learning / mlops as 'machine learning' ... see Kaggle survey
    when {{ column_name }} like '%machine%learning%' then 'machine learning'
    when {{ column_name }} like 'ml%' then 'machine learning'
    when {{ column_name }} like 'ai%engineer%' then 'machine learning' -- *
    when {{ column_name }} like 'ai%scientist%' then 'machine learning' -- *

    when {{ column_name }} like '%market%sale%' then 'marketing/sales'
    when {{ column_name }} like '%sale%market%' then 'marketing/sales'

    when {{ column_name }} like '%manager%' and {{ column_name }} not like '%pro%manager%' then 'manager'

    when {{ column_name }} like 'research%' then 'research'
    when {{ column_name }} like 'senior exec%' then 'senior executive'
    when {{ column_name }} like 'na' or {{ column_name }} like '%other%' then 'other'
    else {{ column_name }}
  end
{% endmacro %}