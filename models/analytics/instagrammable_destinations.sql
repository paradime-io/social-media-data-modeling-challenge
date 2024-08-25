-- instagrammable_destinations
{{
  config(
    materialized = 'table',
    database = 'analytics'
  )
}}

with final as (
    select *
    from
        {{ ref('int_instagrammable_destinations') }}
)

select * from final
