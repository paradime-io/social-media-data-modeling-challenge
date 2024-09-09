{% macro outlier_upper_fence(field) %}
1.5 * (quantile_disc({{field}}, 0.75) - quantile_disc({{field}}, 0.25)) + quantile_disc({{field}}, 0.75)
{% endmacro %}


