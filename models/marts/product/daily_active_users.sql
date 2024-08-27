{{ config(
    materialized='incremental',
    unique_key='event_date'
) }}

SELECT
    DATE_TRUNC('day', created_at) AS event_date,
    COUNT(DISTINCT user_id) AS daily_active_users,
    COUNT(DISTINCT CASE WHEN event_type = 'PushEvent' THEN user_id END) AS daily_active_contributors
FROM {{ ref('fct_github_events') }}
{% if is_incremental() %}
WHERE DATE_TRUNC('day', created_at) > (SELECT MAX(event_date) FROM {{ this }})
{% endif %}
GROUP BY 1