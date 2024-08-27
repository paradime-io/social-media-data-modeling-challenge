{{ config(materialized='table',  schema='dbt_github_analytics.marts.core') }}

SELECT DISTINCT
    actor_login AS user_id,
    MIN(created_at) AS first_seen_at,
    MAX(created_at) AS last_seen_at,
    COUNT(DISTINCT org_login) AS organization_count
FROM {{ ref('stg_github_events') }}
GROUP BY 1