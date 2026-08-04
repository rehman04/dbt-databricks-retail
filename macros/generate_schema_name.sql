{#
    Overrides dbt's built-in generate_schema_name macro.

    Default dbt behaviour: {target.schema}_{custom_schema_name}  (e.g. dev_bronze)
    Our behaviour:          {custom_schema_name}                  (e.g. bronze)

    Why: in Unity Catalog, the CATALOG already separates environments
    (dev/staging/prod via target.database), so the SCHEMA is free to be used
    purely to represent the medallion layer (bronze/silver/gold). A model
    gets its schema from `+schema: bronze` in dbt_project.yml or a model config.
#}
{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}

{%- endmacro %}
