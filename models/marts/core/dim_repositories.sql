{{ config(materialized='table') }}

SELECT DISTINCT
    repo_name AS repository_id,
    SPLIT_PART(repo_name, '/', 1) AS owner,
    SPLIT_PART(repo_name, '/', 2) AS repo_name,
    MAX(public) AS is_public,
    MIN(created_at) AS first_event_at,
    MAX(created_at) AS last_event_at
FROM {{ ref('stg_github_events') }}
GROUP BY 1