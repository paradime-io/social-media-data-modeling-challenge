{{ config(materialized='view') }}

SELECT
    DATE_TRUNC('day', created_at) AS event_date,
    repo_name,
    event_type,
    COUNT(*) AS event_count,
    COUNT(DISTINCT user_id) AS unique_actors
FROM {{ ref('stg_github_events') }}
GROUP BY 1, 2, 3