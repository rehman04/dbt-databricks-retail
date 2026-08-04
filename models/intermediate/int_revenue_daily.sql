{{ config(materialized='view') }}

with orders_enriched as (

    select * from {{ ref('int_orders_enriched') }}

),

daily as (

    select
        order_date,
        count(distinct order_id) as order_count,
        sum(total_amount_gbp) as daily_revenue_gbp

    from orders_enriched
    group by order_date

)

select * from daily
