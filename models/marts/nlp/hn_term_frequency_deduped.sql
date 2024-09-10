select * from {{ref('hn_term_frequency')}}
qualify row_number() over (partition by hn_id order by is_present desc, text_subcategory) = 1