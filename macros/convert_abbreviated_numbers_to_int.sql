{%- macro convert_abbreviated_numbers_to_int(column_name) -%}
    case
        when {{ column_name }} like '%K' then cast(cast(replace({{ column_name }}, 'K', '') as float) * 1000 as int)
        when {{ column_name }} like '%M' then cast(cast(replace({{ column_name }}, 'M', '') as float) * 1000000 as int)
        when lower({{ column_name }}) in ('--') then null
        else cast(replace({{ column_name }}, ',', '') as int)
    end
{%- endmacro -%}