{{ config(materialized='view') }}

with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

order_items as (

    select * from {{ ref('stg_order_items') }}

),

order_item_agg as (

    select
        order_id,
        count(*) as item_count,
        sum(quantity) as total_units,
        sum(line_item_total_gbp) as computed_total_gbp

    from order_items
    group by order_id

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        customers.first_name,
        customers.last_name,
        customers.email,
        customers.country_code,
        orders.order_date,
        orders.order_status,
        orders.total_amount_gbp,
        order_item_agg.item_count,
        order_item_agg.total_units,
        order_item_agg.computed_total_gbp,
        -- QA signal: flags drift between the order header total and the sum
        -- of its line items (e.g. undiscounted line items, data entry error).
        orders.total_amount_gbp - order_item_agg.computed_total_gbp as amount_variance_gbp

    from orders
    left join customers on orders.customer_id = customers.customer_id
    left join order_item_agg on orders.order_id = order_item_agg.order_id

)

select * from final
