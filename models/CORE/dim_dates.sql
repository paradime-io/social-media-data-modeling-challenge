{{ config(
    materialized="view"
) }}

WITH dates AS (
    {{ dbt_date.get_date_dimension('2020-01-01', '2024-12-31') }}
)

SELECT
    strftime('%Y%m%d', CAST(date_day AS DATE)) AS date_id,
    *
FROM
    dates