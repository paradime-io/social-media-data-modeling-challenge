{%- macro pivot_medals(column_name, medal_type) -%}
    sum(case
        {% if medal_type == 'total' %}
        when {{ column_name }} is not null
        {% else %}
        when {{ column_name }} = {{ medal_type }}
        {% endif %}
        then 1
        else 0
    end)
{%- endmacro -%}