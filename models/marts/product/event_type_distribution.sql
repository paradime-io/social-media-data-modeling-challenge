{{ config(
    materialized='incremental',
    unique_key=['event_date', 'event_type']
) }}

SELECT
    DATE_TRUNC('day', created_at) AS event_date,
    event_type,
    COUNT(*) AS event_count,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY DATE_TRUNC('day', created_at)) AS event_percentage
FROM {{ ref('fct_github_events') }}
{% if is_incremental() %}
WHERE DATE_TRUNC('day', created_at) > (SELECT MAX(event_date) FROM {{ this }})
{% endif %}
GROUP BY 1, 2