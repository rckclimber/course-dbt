


with source as (

    select * from  {{ source('greenery','events') }}
),

renamed as ( 

    SELECT
        event_id
        , session_id
        , user_id
        , event_type
        , page_url
        , created_at as created_at_utc
        , order_id
        , product_id
        , case 
            when order_id IS NOT NULL then 'success'
            else 'abandoned' 
            end as session_result
    from source
)

select * from renamed