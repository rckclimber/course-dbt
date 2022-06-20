{{
    config (
        materialized = 'table'
    )
}}


with products as (
    select * from {{ref('stg_products')}}

),

item_qty_ordered as (
    select 
        product_id
        , count(order_id) as no_of_times_ordered
        , sum(quantity) as total_ordered
    
    from {{ref('stg_orderitems')}}
    GROUP BY 1
),

final as (
    select 
    p.product_id
    , p.name
    , p.price
    , p.inventory
    , itq.no_of_times_ordered
    , itq.total_ordered
    from products p
    left join item_qty_ordered itq on itq.product_id = p.product_id
)

select * from final