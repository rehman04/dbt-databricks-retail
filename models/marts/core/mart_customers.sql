{{ config(materialized='table') }}

-- Databricks tip: OPTIMIZE {{ this }} ZORDER BY (customer_id)
-- once row counts grow — this table is typically joined/filtered by customer_id.

with customer_orders as (

    select * from {{ ref('int_customer_orders') }}

),

segmented as (

    select
        *,
        case
            when lifetime_value_gbp >= 500 then 'high_value'
            when lifetime_value_gbp >= 100 then 'mid_value'
            else 'low_value'
        end as customer_segment

    from customer_orders

)

select * from segmented
