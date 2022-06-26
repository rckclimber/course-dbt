{% macro delivery_status(est_date,del_date)%}
Case 
    when ({{est_date}} < {{del_date}}) and ({{del_date}} is not null) then 'delayed'
    when ({{est_date}} > {{del_date}}) and ({{del_date}} is not null) then 'early'
    when ({{est_date}} = {{del_date}}) and ({{del_date}} is not null) then 'on-time'
END
{% endmacro %}
