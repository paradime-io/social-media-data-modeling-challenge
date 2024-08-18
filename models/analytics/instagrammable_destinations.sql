-- instagrammable_destinations

with final as (
    select *
    from
        {{ ref('int_instagrammable_destinations') }}
)

select * from final
