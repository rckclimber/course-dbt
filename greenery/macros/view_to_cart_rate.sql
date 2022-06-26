{% macro view_to_cart_rate(no_of_add_to_cart,no_of_page_views)%}
    round (({{no_of_add_to_cart}} / {{no_of_page_views}}),2)
{% endmacro %}