
{% set event_types =  dbt_utils.get_query_results_as_dict(
    "select distinct quote_literal(event_type) as event_type, event_type as column_name from" ~ ref('stg_events')
    )
%}

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
        {% for event_type in event_types['event_type'] %}
            , sum(case when event_type = {{event_type}} then 1 else 0 end) as {{event_types['column_name'][loop.index0]}}
        {% endfor %}
    FROM
        events
    group by 1,2
)

select * from final