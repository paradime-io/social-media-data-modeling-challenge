{% snapshot snapshot_github_events %}

{{
    config(
      target_database='dbt_github_analytics',
      target_schema='snapshots',
      unique_key='event_id',
      strategy='timestamp',
      updated_at='created_at',
    )
}}

SELECT * FROM {{ ref('stg_github_events') }}

{% endsnapshot %}