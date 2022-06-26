
with sl as (
    select * from {{ref('int_session_length_agg')}}
),

session_events as (
    select * from {{ref('int_session_events_agg')}}
),

users as (
    select * from {{ref('stg_users')}}
),

final as (
    select
         sl.session_id
        , sl.user_id
        , concat(users.first_name,' ',users.last_name) as user_name
        --, sl.session_result
        , sl.session_starts
        , sl.session_ends
        , sl.session_length_minutes
        , session_events.no_of_events_in_session
        , session_events.no_of_orders_in_session
        , session_events.no_of_products_viewed
        , session_events.checkout
        , session_events.package_shipped
        , session_events.add_to_cart
        , session_events.page_view
    from sl
    left join session_events on session_events.session_id = sl.session_id
    left join users on users.user_id = sl.user_id
)

select * from final