{{ config(materialized='view') }}

with orders_enriched as (

    select * from {{ ref('int_orders_enriched') }}

),

customer_agg as (

    select
        customer_id,
        first_name,
        last_name,
        email,
        country_code,
        count(distinct order_id) as lifetime_order_count,
        sum(total_amount_gbp) as lifetime_value_gbp,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date

    from orders_enriched
    group by customer_id, first_name, last_name, email, country_code

)

select * from customer_agg
