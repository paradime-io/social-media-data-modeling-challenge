{% macro is_valid_event_type(column_name) %}
    {{ column_name }} IN ('PushEvent', 'PullRequestEvent', 'IssuesEvent', 'WatchEvent', 'ForkEvent')
{% endmacro %}