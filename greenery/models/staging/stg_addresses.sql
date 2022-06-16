{{
    config (
        materialized = 'table'
    )
}}

With source as (

    Select * from {{ source('greenery','addresses') }}
),

renamed as (


SELECT
    address_id
    , address
    , zipcode
    , state
    , country
FROM source
)

Select * from renamed
