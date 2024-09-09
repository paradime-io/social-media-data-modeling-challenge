{%- macro missing_member_column(primary_key, referential_integrity_columns=[], not_null_test_cols=[]) -%}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}

    {%- set columns = adapter.get_columns_in_relation(this) -%}
    {%- set referential_integrity_columns = referential_integrity_cols|list -%}
    {%- set not_null_test_columns = not_null_test_cols|list -%}
    {%- set target = this -%}

    {# -- Step 1: Create the source with default values -- #}
    {%- set source %}
    (
        SELECT DISTINCT
          {%- for col in columns %}
            {% if (col.name|lower == primary_key and  col.data_type.startswith('character varying')) %}
            MD5('-1') AS {{ col.name|lower }}
            --- for date _sk columns
            {% elif 'date_sk' in col.name|string %}
            19000101 AS {{ col.name|lower }}
            {% elif ('_sk' in col.name|string and col.data_type.startswith('character varying')) %}
            MD5('-1') AS {{ col.name|lower }}
            -- if the column is part of a relationship test, set it to -1 so this test does not fail
            {% elif col.name|lower in referential_integrity_columns|lower %}
            MD5('-1') AS {{ col.name|lower }}
            -- if the column is part of a not null test, set it to 0 so this test does not fail
            {% elif col.name|lower in not_null_test_columns|lower %}
            '0' AS {{ col.name|lower }}
            -- if the column contains "_ID" this indicates it is an id so assign it "-1" or the hash of -1
            {% elif ('_id' in col.name|string and col.data_type.startswith('character varying')) %}
            MD5('-1') AS {{ col.name|lower }}
            {% elif ('_id' in col.name|string and col.data_type.startswith('numeric')) %}
            -1 AS {{ col.name|lower }}
             {% elif ('_id' in col.name|string and col.data_type.startswith('BIGINT')) %}
            -1 AS {{ col.name|lower }}
            {% elif col.name|string == 'IS_DELETED' %}
            '0' AS {{ col.name|lower }}
            -- boolean
            {% elif col.data_type == 'BOOLEAN' %}
            FALSE AS {{ col.name|lower }}
            -- strings
            {% elif (col.data_type.startswith('character varying') and ('_desc' in col.name|string or '_title' in col.name|string)) %}
            'Unknown' AS {{ col.name|lower }}
            {% elif (col.data_type.startswith('character varying') and '_code' in col.name|string) %}
            '--' AS {{ col.name|lower }}
            -- dates
            {% elif col.data_type == 'DATE' %}
            '1900-01-01' AS {{ col.name|lower }}
            {% elif col.data_type == 'DATETIME' %}
            '1900-01-01 00:00:00.000 +0000' AS {{ col.name|lower }}
            {% elif 'etl_timestamp' in col.name|string %}
            CURRENT_TIMESTAMP AS {{ col.name|lower }}
            -- numeric
            {% elif col.data_type.startswith('NUMBER') %}
            NULL AS {{ col.name|lower }}
            -- catch all for everything else
            {% else %}
            NULL AS {{ col.name|lower }}
            {%- endif %}
            {%- if not loop.last %}
            ,
            {%- endif %}
          {%- endfor %}
      FROM {{ target }}
      LIMIT 1
    )
    {%- endset %}

    {# -- Step 2: DELETE the existing row where the primary key is MD5('-1') -- #}
    DELETE FROM {{ target }}
    WHERE {{ primary_key }} = MD5('-1');

    {# -- Step 3: INSERT the default values into the target table -- #}
    INSERT INTO {{ target }} (
        SELECT * FROM {{ source }}
    );

{%- endmacro -%}
