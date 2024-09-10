select * from 
--  analytics.raw_data.trending_related_terms
{{source('raw_data', 'trending_related_terms')}}