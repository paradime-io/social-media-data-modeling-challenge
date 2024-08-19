{% macro normalize_value(column_name) %}
(
    ({{ column_name }} - (SELECT MIN({{ column_name }}) FROM {{ this }})) /
    NULLIF((SELECT MAX({{ column_name }}) FROM {{ this }}) - (SELECT MIN({{ column_name }}) FROM {{ this }}), 0)
)
{% endmacro %}