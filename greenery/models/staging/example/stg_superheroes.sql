{{
    config (
        materrialized = 'view'
    )
}}

SELECT
    id as superhero_id
    , name
    , gender
    , eye_color
    , race 
    , hair_color
    , NULLIF(height, -99) AS height
    , publisher
    , skin_color
    , alignment
    , NULLIF(weight, -99) as weight_lbs
 /*   , {{ lbs_to_kgs(weight) }} as weight_kg */
FROM  {{ source('tutorial','superheroes') }}