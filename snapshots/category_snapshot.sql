{% snapshot category_snapshot %}

{{
    config(
      target_database='analytics',
      target_schema='snapshots',
      unique_key='dim_yt_category_sk',
      updated_at = 'category_date',
      strategy='check',
      check_cols=['category_business_id'],
       invalidate_hard_deletes=True,
    )
}}

select *,
CAST ('2999-01-01' AS DATE) AS valid_to
 from {{ ref('dim_category') }}

{% endsnapshot %}
