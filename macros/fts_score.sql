{% macro fts_score(query, id='id', fields='text_value') %}
    {% set query_str=query %}
    {% set fields_str=fields %}

    analytics.fts_raw_data_entity_text.match_bm25(
        {{id}},
        '{{query_str}}',
        fields := '{{fields_str}}',
        conjunctive := 1
    )
{% endmacro %}

