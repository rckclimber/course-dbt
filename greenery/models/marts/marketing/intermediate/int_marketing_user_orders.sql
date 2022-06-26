


with orders as (

    select * from {{ ref('stg_orders')}}
),

orderitems as (

    select * from {{ ref('stg_orderitems')}}
),

final as ( 

    select 
        orders.user_id
        , min(orders.created_at_utc) as first_order
        , max(orders.created_at_utc) as last_order
        , count(distinct orders.order_id) as total_orders_lifetime
        , count(distinct orderitems.product_id) as unique_items_ordered
        , sum(orders.order_total) as total_spends_lifetime
        , sum(orders.order_total) / count(distinct orders.order_id)  as avg_order_spend_lifetime
        , extract(day from CURRENT_DATE::timestamp - MAX(orders.created_at_utc::timestamp)) as days_since_last_order
        from orders
        left join orderitems on orderitems.order_id = orders.order_id
        group by 1
)

select * from final

/*
select 
        users.user_id
        , count(orders.order_id) over (partition by orders.user_id) as no_of_orders
        , sum(orders.order_total) over (partition by orders.user_id) as total_spent
        , avg(orders.order_total) over (partition by orders.user_id) as avg_order_spend
        , extract(day from CURRENT_DATE::timestamp - MAX(orders.created_at_utc::timestamp)) as days_since_last_order
        from orders
*/