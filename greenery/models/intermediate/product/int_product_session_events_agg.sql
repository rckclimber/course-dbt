
{%- set event_types = ['checkout','package_shipped','add_to_cart','page_view'] -%}

with events as (
    select * from {{ref('stg_events')}}
),

final as (
    select
        session_id
        , user_id
        , count(event_id) as no_of_events_in_session
        {% for event_type in event_types -%}
            , sum(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}
        {%- endfor %}
    FROM
        events
    group by 1,2
)

select * from final