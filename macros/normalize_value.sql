{% macro normalize_value(column_name) %}
    (
        ({{ column_name }} - MIN({{ column_name }}) OVER ()) /
        NULLIF(MAX({{ column_name }}) OVER () - MIN({{ column_name }}) OVER (), 0)
    )
{% endmacro %}