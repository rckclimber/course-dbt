{% macro grant_permissions(role) %}

    {% set sql %}
   /*"grant select on all tables in schema  {{ target.schema }} to group reporting"*/
      GRANT select ON all tables in SCHEMA {{ schema }} TO group {{ role }};
      /* GRANT SELECT ON {{ this }} TO ROLE {{ role }};*/
    {% endset %}

    {% set table = run_query(sql) %}

{% endmacro %}