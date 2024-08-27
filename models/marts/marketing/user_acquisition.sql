{{ config(
    materialized='incremental',
    unique_key='acquisition_date',
    schema='marts.marketing'
) }}

SELECT
    DATE_TRUNC('day', first_seen_at) AS acquisition_date,
    COUNT(DISTINCT user_id) AS new_users
FROM {{ ref('dim_users') }}
{% if is_incremental() %}
WHERE DATE_TRUNC('day', first_seen_at) > (SELECT MAX(acquisition_date) FROM {{ this }})
{% endif %}
GROUP BY 1