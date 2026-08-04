{{ config(materialized='table') }}

with daily_revenue as (

    select * from {{ ref('int_revenue_daily') }}

),

windowed as (

    select
        order_date,
        order_count,
        daily_revenue_gbp,
        sum(daily_revenue_gbp) over (
            order by order_date
            rows between 6 preceding and current row
        ) as rolling_7_day_revenue_gbp,
        sum(daily_revenue_gbp) over (
            order by order_date
            rows between 29 preceding and current row
        ) as rolling_30_day_revenue_gbp

    from daily_revenue

)

select * from windowed
