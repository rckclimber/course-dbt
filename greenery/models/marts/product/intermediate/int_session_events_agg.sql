

with events as (
    select * from {{ref('stg_events')}}
),

final as (
    select
        session_id
        , user_id
        , min(created_at_utc) as session_start
        , max(created_at_utc) as session_end
        , count(distinct order_id) as no_of_orders_in_session
        , count(distinct product_id) as no_of_products_viewed
        , count(event_id) as no_of_events_in_session
         {{ events_to_cols_agg() }}
    FROM
        events
    group by 1,2
)

select * from final