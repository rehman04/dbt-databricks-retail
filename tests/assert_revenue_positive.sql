-- Singular test: dbt fails this test if the query returns ANY rows.
-- Business rule: aggregated daily revenue should never be negative — a
-- negative value signals a data quality issue (bad join, broken refund
-- logic) rather than a legitimate business state.

select *
from {{ ref('mart_revenue_summary') }}
where daily_revenue_gbp < 0
