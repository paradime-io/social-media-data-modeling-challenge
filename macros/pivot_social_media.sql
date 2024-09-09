{%- macro pivot_social_media(column_name, social_media, url) -%}
    max(case
        when {{ column_name }} = '{{ social_media }}'
        then {{ url }}
        else null
    end)
{%- endmacro -%}