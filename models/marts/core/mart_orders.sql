{{ config(materialized='table') }}

-- Databricks tip: once this table has meaningful volume, run
--   OPTIMIZE {{ this }} ZORDER BY (customer_id, order_date)
-- to co-locate rows commonly filtered together (BI dashboards typically
-- filter by customer and date range).

with orders_enriched as (

    select * from {{ ref('int_orders_enriched') }}

)

select
    order_id,
    customer_id,
    first_name,
    last_name,
    email,
    country_code,
    order_date,
    order_status,
    total_amount_gbp,
    item_count,
    total_units,
    computed_total_gbp,
    amount_variance_gbp

from orders_enriched
