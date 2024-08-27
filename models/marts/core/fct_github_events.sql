{{ config(
    materialized='incremental',
    unique_key='event_id'
) }}

SELECT DISTINCT  -- Add DISTINCT to remove duplicates
    event_id,
    created_at,
    actor_login AS user_id,
    repo_name AS repository_id,
    event_type,
    push_size,
    event_details_text,
    public,
    org_login
FROM {{ ref('stg_github_events') }}