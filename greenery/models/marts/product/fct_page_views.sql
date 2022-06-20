
with session_length as (
    select * from {{ref('int_product_agg_session_length')}}
),

session_events as (
    select * from {{ref('int_product_session_events_agg')}}
),

users as (
    select * from {{ref('stg_users')}}
),

final as (
    select
        , session_length.session_id
        , session_length.user_id
        , concat(users.first_name,' 'users.last_name) as user_name
        , session_length.session_start
        , session_length.session_ends
        , session_events.no_of_events_in_session
        , session_events.checkout
        , session_events.package_shipped
        , session_events.add_to_cart
        , session_events.page_view
    from session_length
    left join session_events on session_events.session_id = session_length.session_id
    left join users on users.user_id = session_length.user_id
)

select * from final