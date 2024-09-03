{% snapshot channel_snapshot %}

{{
    config(
      target_database='analytics',
      target_schema='snapshots',
      unique_key='dim_yt_channel_sk',
      updated_at='trending_date',
      strategy='check',
      check_cols=['channel_title'],
      invalidate_hard_deletes=True,
    )
}}

select *,
CAST ('2999-01-01' AS DATE) AS valid_to
 from {{ ref('dim_current_channel') }}

{% endsnapshot %}
