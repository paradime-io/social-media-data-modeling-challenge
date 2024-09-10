{% set terms = dbt_utils.get_column_values(
    table=ref("stg_gt__trending_related_terms"), column="keyword"
) %}

{% set terms_str = terms | map('replace', ' ', '_') | join(', ') %}

select
    kw_unpivot.* exclude (term_name, is_present),
    related_terms.topic,
    related_terms.subtopic,
    kw_unpivot.term_name,
    kw_unpivot.is_present
from (
    unpivot {{ ref('int_hn__entity_text_kw_search') }}
    on {{ terms_str }}
    into name term_name
    value is_present
) as kw_unpivot
left join {{ ref('stg_gt__trending_related_terms') }} as related_terms on
    kw_unpivot.term_name = replace(related_terms.keyword, ' ', '_')
