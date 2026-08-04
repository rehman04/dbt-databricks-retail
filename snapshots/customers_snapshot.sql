{#
    SCD Type 2 snapshot of the raw customers source.

    CAVEAT: `strategy: timestamp` compares the `updated_at` column to decide
    whether a row has changed since the last snapshot run. raw_customers only
    provides `created_at` (set once at signup, never updated), so this
    snapshot will correctly capture NEW customers over time, but cannot
    detect attribute changes (e.g. an email update) on EXISTING customers —
    there's no real "last modified" signal in the source to compare against.
    In production, ask the upstream system to maintain a genuine updated_at
    column; until then, this is an honest limitation, not a bug.
#}
{% snapshot customers_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='customer_id',
      strategy='timestamp',
      updated_at='created_at',
    )
}}

select
    customer_id,
    first_name,
    last_name,
    email,
    country_code,
    created_at

from {{ source('retail_raw', 'raw_customers') }}

{% endsnapshot %}
