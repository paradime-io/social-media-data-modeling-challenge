{% macro group_by(n) %}
  {% set group_by_list = [] %}
  {% for i in range(1, n + 1) %}
    {% do group_by_list.append(loop.index|string) %}
  {% endfor %}
  group by {{ group_by_list | join(', ') }}
{% endmacro %}