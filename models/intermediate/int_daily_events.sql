{{ config(
    materialized='incremental',
    unique_key='event_date',
    schema='int'
) }}

SELECT
    DATE_TRUNC('day', created_at) AS event_date,
    event_type,
    COUNT(*) AS event_count,
    COUNT(DISTINCT actor_login) AS unique_users,
    SUM(CASE WHEN public THEN 1 ELSE 0 END) AS public_event_count,
    SUM(CASE WHEN org_login IS NOT NULL THEN 1 ELSE 0 END) AS org_event_count,
    AVG(COALESCE(push_size, 0)) AS avg_push_size
FROM {{ ref('stg_github_events') }}
GROUP BY 1, 2