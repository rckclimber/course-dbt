{% macro conversion_rate(no_of_times_ordered,no_of_page_views) %}

    round(({{no_of_times_ordered}} / {{no_of_page_views}}),2)
    
{% endmacro%}