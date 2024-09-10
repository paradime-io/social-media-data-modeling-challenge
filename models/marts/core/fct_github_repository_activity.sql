{{ config(materialized='table') }}

SELECT
    event_date,
    repo_name,
    SUM(CASE WHEN event_type = 'PushEvent' THEN event_count ELSE 0 END) AS push_events,
    SUM(CASE WHEN event_type = 'PullRequestEvent' THEN event_count ELSE 0 END) AS pr_events,
    SUM(CASE WHEN event_type = 'IssuesEvent' THEN event_count ELSE 0 END) AS issue_events,
    SUM(CASE WHEN event_type = 'WatchEvent' THEN event_count ELSE 0 END) AS watch_events,
    SUM(CASE WHEN event_type = 'ForkEvent' THEN event_count ELSE 0 END) AS fork_events,
    SUM(event_count) AS total_events,
    SUM(unique_actors) AS total_unique_actors
FROM {{ ref('int_github_daily_activity') }}
GROUP BY 1, 2