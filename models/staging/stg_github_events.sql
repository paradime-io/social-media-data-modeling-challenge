{{ config(
    materialized='incremental',
    unique_key='event_id'
) }}

SELECT
    {{ dbt_utils.surrogate_key(['created_at', 'actor_login', 'repo_name', 'event_type']) }} AS event_id,
    created_at,
    actor_login AS user_id,  -- Assuming actor_login is equivalent to user_id
    repo_name,
    event_type,
    CASE
        WHEN event_type = 'PushEvent' THEN CAST(event_details AS INTEGER)
        ELSE NULL
    END AS push_size,
    CASE
        WHEN event_type != 'PushEvent' THEN event_details
        ELSE NULL
    END AS event_details_text,
    public,
    org_login
FROM {{ source('raw', 'github_events') }}
WHERE {{ is_valid_event_type('event_type') }}
  AND created_at::date >= DATE '{{ var("start_date") }}'
  AND created_at::date <= DATE '{{ var("end_date") }}'
{% if is_incremental() %}
  AND created_at > (SELECT MAX(created_at) FROM {{ this }})
{% endif %}