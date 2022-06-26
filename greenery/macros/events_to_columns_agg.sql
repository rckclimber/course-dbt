{% macro events_to_cols_agg() %}

{% set sql_stmt %}

select distinct quote_literal(event_type) as event_type, event_type as column_name from  {{ref('stg_events')}}

{% endset%}

{% set event_types =  dbt_utils.get_query_results_as_dict(sql_stmt)%}

{% for event_type in event_types['event_type'] %}
    
    , sum(case when event_type = {{event_type}} then 1 else 0 end) as {{event_types['column_name'][loop.index0]}}

{% endfor %}

{% endmacro %}