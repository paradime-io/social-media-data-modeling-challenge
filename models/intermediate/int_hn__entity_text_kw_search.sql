{% set terms = dbt_utils.get_column_values(
    table=ref("stg_gt__trending_related_terms"), column="keyword"
) %}


select
    *,
    {% for term in terms %}
        case when {{ fts_score(term) }} is not null then 1 else 0 end as "{{ term | lower() | replace(' ', '_') }}",
    {% endfor %}
from {{ ref('stg_hn__entity_text') }}
