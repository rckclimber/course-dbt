{{
    config (
        materialized = 'table'
    )
}}


with userorders as (

    select * from {{ ref('int_core_user_orders')}}
),

addresses as (
    select * from {{ref('stg_addresses')}}
),

orders as (
    select * from {{ref('stg_orders')}}
),

final as ( 

    select 
        us.user_id
        , concat (users.first_name, ' ', users.last_name) as user_name
        , users.email
        , users.phone_number
        , us.first_order
        , us.last_order
        , us.total_orders_lifetime
        , us.total_spends_lifetime
        , addresses.zipcode
        , addresses.state
        , addresses.country
        from userorders us
        left join users on users.user_id = us.user_id
        left join addresses on users.address_id = addresses.address_id
)

select * from final