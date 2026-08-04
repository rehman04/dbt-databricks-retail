{{ config(materialized='view') }}

with source as (

    select * from {{ source('retail_raw', 'raw_products') }}

),

renamed as (

    select
        product_id,
        product_name,
        category,
        {{ cents_to_pounds('price_pence') }} as unit_price_gbp,
        is_active

    from source

)

select * from renamed
