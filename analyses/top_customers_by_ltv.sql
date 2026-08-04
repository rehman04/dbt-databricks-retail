-- Ad-hoc exploration query — compiled by `dbt compile` (see target/compiled/)
-- but never run or materialized. Useful for one-off analysis you still want
-- to write with dbt's ref/source Jinja and version-control alongside the project.

select
    customer_id,
    first_name,
    last_name,
    country_code,
    lifetime_order_count,
    lifetime_value_gbp,
    customer_segment

from {{ ref('mart_customers') }}

order by lifetime_value_gbp desc
limit 20
