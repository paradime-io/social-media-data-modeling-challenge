{% macro generate_column_yaml(column, model_yaml, table_name, parent_column_name="") %}
    {% if parent_column_name %}
        {% set column_name = parent_column_name ~ "." ~ column.name %}
    {% else %}
        {% set column_name = column.name %}
    {% endif %}

    {% set doc_string = table_name ~ '__' ~ column.name | lower %}
    {% do model_yaml.append('      - name: ' ~ column.name | lower ) %}
    {% do model_yaml.append('        description: |\n          {{ doc("' ~ doc_string ~ '") }}') %}
    {% do model_yaml.append('') %}

    {% if column.fields|length > 0 %}
        {% for child_column in column.fields %}
            {% set model_yaml = generate_column_yaml(child_column, model_yaml, parent_column_name=column_name, table_name=table_name) %}
        {% endfor %}
    {% endif %}
    {% do return(model_yaml) %}
{% endmacro %}

{% macro generate_column_docs(column, model_docs, column_desc_dict, table_name, parent_column_name="") %}
    {% if parent_column_name %}
        {% set column_name = parent_column_name ~ "." ~ column.name %}
    {% else %}
        {% set column_name = column.name %}
    {% endif %}

    {% set md_doc_string = table_name ~ '__' ~ column.name | lower %}
    {% do model_docs.append('{% docs ' ~ md_doc_string ~ ' %}') %}
    {% do model_docs.append('"' ~ column_desc_dict.get(column.name | lower,'') ~ '"') %}
    {%- do model_docs.append('{% enddocs %}' ~ '\n') %}



    {% if column.fields|length > 0 %}
        {% for child_column in column.fields %}
            {% set model_docs = generate_column_docs(child_column, model_docs, column_desc_dict, parent_column_name=column_name, table_name=table_name) %}
        {% endfor %}
    {% endif %}
    {% do return(model_docs) %}
{% endmacro %}

{% macro generate_model_yaml(model_name, upstream_descriptions=False, vertical=None) %}

{% set model_yaml=[] %}
{% set model_markdown=[] %}

{% set column_desc_dict =  codegen.build_dict_column_descriptions(model_name) if upstream_descriptions else {} %}


{% do model_yaml.append('\n') %}
{% do model_yaml.append('  - name: ' ~ model_name | lower) %}
{% do model_yaml.append('    description:  |
        Table description 
') %}
{% do model_yaml.append('    columns:') %}

{% do model_markdown.append('# ' ~ model_name ~ '\n') %}

{% set relation=ref(model_name) %}
{%- set columns = adapter.get_columns_in_relation(relation) -%}

{% set id_columns = [] %}
{% set date_columns = [] %}
{% set other_columns = [] %}
{% for column in columns %}
    {% if column.name.lower().endswith('_id') or column.name.lower().endswith('id')%}
        {% do id_columns.append(column) %}
    {% elif column.name.lower().endswith('_date') or column.name.lower().endswith('_at') %}
        {% do date_columns.append(column) %}
    {% else %}
        {% do other_columns.append(column) %}
    {% endif %}
{% endfor %}

{% set id_columns = id_columns | sort(attribute='name') %}
{% set date_columns = date_columns | sort(attribute='name') %}
{% set other_columns = other_columns | sort(attribute='name') %}

{% set updated_columns = id_columns + other_columns + date_columns %}

{% for column in updated_columns %}
    {% set model_yaml = generate_column_yaml(column, model_yaml, model_name) %}
{% endfor %}

{% for column in updated_columns %}
    {% set model_markdown = generate_column_docs(column, model_markdown, column_desc_dict, model_name) %}
{% endfor %}

{% if execute %}

    {% set joined_yaml = model_yaml | join('\n') %}
    {% set joined_docs = model_markdown | join('\n') %}
    
    {{ log(joined_yaml, info=True) }}
    {{ log(joined_docs, info=True) }}
    
    {% do return(joined_docs)%}
    
    {% do return({
        'yaml': joined_yaml,
        'docs': joined_docs
    }) %}

{% endif %}

{% endmacro %}
