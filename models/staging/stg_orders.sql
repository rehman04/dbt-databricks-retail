{{ config(materialized='view') }}

with source as (

    select * from {{ source('retail_raw', 'raw_orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,
        status as order_status,
        {{ cents_to_pounds('total_amount_pence') }} as total_amount_gbp

    from source

)

select * from renamed
