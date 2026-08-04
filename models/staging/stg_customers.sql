{{ config(materialized='view') }}

with source as (

    select * from {{ source('retail_raw', 'raw_customers') }}

),

renamed as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        country_code,
        created_at as customer_created_at

    from source

)

select * from renamed
