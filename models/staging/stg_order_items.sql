{{ config(materialized='view') }}

with source as (

    select * from {{ source('retail_raw', 'raw_order_items') }}

),

renamed as (

    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        {{ cents_to_pounds('unit_price_pence') }} as unit_price_gbp,
        quantity * {{ cents_to_pounds('unit_price_pence') }} as line_item_total_gbp

    from source

)

select * from renamed
