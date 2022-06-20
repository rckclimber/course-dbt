{{
    config (
        materialized = 'table'
    )
}}


with userorders as (

    select * from {{ ref('int_marketing_user_orders')}}
),

addresses as (
    select * from {{ref('stg_addresses')}}
),


final as ( 

    select 
        us.user_id
        , concat (users.first_name, ' ', users.last_name) as user_name
        , us.first_order
        , us.last_order
        , us.total_orders_lifetime
        , us.total_spends_lifetime
        , us.unique_items_ordered
        , us.avg_order_spend_lifetime
        , us.days_since_last_order
        from userorders us
        left join users on users.user_id = us.user_id
        left join addresses on users.address_id = addresses.address_id
)

select * from final