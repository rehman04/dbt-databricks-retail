{#
    Converts an integer pence column (no floating-point rounding issues in
    the raw source) into a decimal pounds value for reporting.

    Usage in a model:  {{ cents_to_pounds('total_amount_pence') }} as total_amount_gbp
#}
{% macro cents_to_pounds(column_name) -%}
    round(cast({{ column_name }} as decimal(18,2)) / 100.0, 2)
{%- endmacro %}
