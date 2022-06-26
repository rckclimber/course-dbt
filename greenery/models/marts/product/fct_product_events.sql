
with product_order as (
    select * from {{ ref('dim_products')}}
),

product_sessions as (
    select * from {{ ref ('int_product_sessions_agg')}} 
),

final as (
    select 
    product_order.product_id
    , product_order.name
    , product_order.no_of_times_ordered
    , product_order.total_qty_ordered
    , product_sessions.no_of_page_views
    , product_sessions.no_of_add_to_cart
    , {{ conversion_rate('no_of_times_ordered::numeric','no_of_page_views::numeric') }} as conversion_rate
    , {{ view_to_cart_rate('no_of_add_to_cart::numeric','no_of_page_views::numeric')}} as page_view_to_cart_rate
    from product_order
    left join product_sessions on product_order.product_id = product_sessions.product_id
)

select * from final