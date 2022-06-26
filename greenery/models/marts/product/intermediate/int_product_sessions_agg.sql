
with products as (
    select * from {{ref('stg_products')}}
),

events as (
    select * from {{ref('stg_events')}}
),

session_to_products as (
    select 
    p.product_id
    , p.name
    , count(p.product_id) as no_of_page_views
    , sum(case when e.event_type = 'add_to_cart' then 1 else 0 end) as no_of_add_to_cart
    
    from
        products p
        left join events e on e.product_id = p.product_id
    GROUP BY 1,2
)
select * from session_to_products