--
{% macro get_job_experience_level(column_name) %}
case 
  when ({{ column_name }} like '%junior%')
    or ({{ column_name }} like '%entry%') then 'entry level'
  
  when ({{ column_name }} like '%mid%') then 'mid level'
  
  when (({{ column_name }} like '%senior%') 
        or ({{ column_name }} like '%sr%')
        or ({{ column_name }} like '%staff%')
        or ({{ column_name }} like '%lead%')
        or ({{ column_name }} like '%principal%')) then 'senior'

  when ({{ column_name }} like '%director%') then 'director'
  
  when ({{ column_name }} like '%manager%') and ({{ column_name }} not like '%pro%manager%') then 'manager'
  else 'na'
end
{% endmacro %}