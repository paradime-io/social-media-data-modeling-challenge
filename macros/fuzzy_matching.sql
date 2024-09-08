-- fuzzy match using Levenshtein distance
-- doc: https://duckdb.org/docs/sql/functions/char.html#text-similarity-functions
-- 	The minimum number of single-character edits 
-- (insertions, deletions or substitutions) required to 
-- change one string to the other. Characters of different cases 
-- (e.g., a and A) are considered different.
{% macro fuzzy_match(text_column, keyword_column, threshold=3) %}
  (
    levenshtein({{ text_column }}, {{ keyword_column }}) <= {{ threshold }}
  )
{% endmacro %}