{% macro extract_hashtags(column_name) %}
  regexp_split_to_table({{ column_name }}, '[^\w#]+') AS hashtag
{% endmacro %}
