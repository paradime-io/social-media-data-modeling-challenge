{% macro group_follower_counts(follower_count_column) %}
    CASE
        WHEN {{ follower_count_column }} < 100 THEN 'a.0-99'
        WHEN {{ follower_count_column }} BETWEEN 100 AND 499 THEN 'b.100-499'
        WHEN {{ follower_count_column }} BETWEEN 500 AND 999 THEN 'c.500-999'
        WHEN {{ follower_count_column }} BETWEEN 1000 AND 4999 THEN 'd.1K-4.9K'
        WHEN {{ follower_count_column }} BETWEEN 5000 AND 9999 THEN 'e.5K-9.9K'
        WHEN {{ follower_count_column }} BETWEEN 10000 AND 49999 THEN 'f.10K-49.9K'
        WHEN {{ follower_count_column }} BETWEEN 50000 AND 99999 THEN 'g.50K-99.9K'
        ELSE 'h.100K+'
    END
{% endmacro %}
