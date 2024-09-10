select * from {{ref('hn_term_frequency')}}
qualify row_number() over (partition by hn_id, text_category, term_name order by is_present desc, text_subcategory) = 1