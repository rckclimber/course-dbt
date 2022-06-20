{{
    config (
        materialized = 'table'
    )
}}


with orders as (

    select * from {{ ref('stg_orders')}}
),

users as (
    select * from {{ref ('stg_users')}}
),

promos AS (
    select * from {{ ref('stg_promos') }}
),

addresses AS (
    select * from {{ref('stg_addresses')}}
),

final as (

    SELECT
    orders.order_id
    , orders.promo_id
    , promos.discount as promo_discount
    , orders.user_id
    , concat(users.first_name,' ', users.last_name) as username
    , orders.address_id
    , addresses.zipcode
    , addresses.state
    , addresses.country
    , orders.created_at_utc
    , orders.order_cost
    , orders.shipping_cost
    , orders.order_total
    , orders.tracking_id
    , orders.shipping_service
    , orders.estimated_delivery_at_utc
    , orders.delivered_at_utc
    , (orders.delivered_at_utc::timestamp - orders.created_at_utc::timestamp) as actual_time_to_delivery
    , (orders.delivered_at_utc::timestamp - orders.estimated_delivery_at_utc::timestamp) as diff_in_estimate_and_actual
    , orders.status as order_status
    from  orders
    left join users on orders.user_id = users.user_id
    left join promos on orders.promo_id = promos.promo_id
    left join addresses on orders.address_id = addresses.address_id
)

select * from final
