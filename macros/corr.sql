{% macro corr(column_a, column_b, table_name) %}

(SELECT
  CAST(
    (SUM(Concordant) / NULLIF(CAST((COUNT(*) / 2) AS DECIMAL(38, 18)), 0))
    AS DECIMAL(38, 18)
  ) AS kendall_tau_coefficient
FROM 
--Concordant
(
  SELECT
    CASE
      WHEN (a1 < a2 AND b1 < b2) OR (a1 > a2 AND b1 > b2) THEN 1
      WHEN (a1 < a2 AND b1 > b2) OR (a1 > a2 AND b1 < b2) THEN -1
      ELSE 0
    END AS Concordant
  FROM 
  -- Pairwise correlations
  (
  SELECT
    a.{{ column_a }} AS a1,
    a.{{ column_b }} AS b1,
    b.{{ column_a }} AS a2,
    b.{{ column_b }} AS b2
  FROM
    {{ table_name }} a
  CROSS JOIN
    {{ table_name }} b
  WHERE
    a.{{ column_a }} <> b.{{ column_a }} OR a.{{ column_b }} <> b.{{ column_b }}
)
)
)
{% endmacro %}
