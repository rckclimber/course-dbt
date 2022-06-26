# week 3 Project Questions and Answers

## Q1: What is our overall conversion rate?
####  Ans: **71%**

Code:
```sql
  select
    round(sum(no_of_orders_in_session::numeric) / count(distinct session_id),2) * 100 as overall_convertion_rate
  from 
    dbt_gaurang_s.fct_session_events
  where no_of_products_viewed::numeric >1 
 
```


## Q2: What is our conversion rate by product?
####  Ans: 
![product conversion rate](product_conversion_rate.png)

Code:
```sql
select 
    name
    , conversation_rate
  from dbt_gaurang_s.fct_product_events
  order by conversation_rate desc
```

## Add a post hook to your project to apply grants to the role “reporting”. Create reporting role first by running CREATE ROLE reporting in your database instance.
### Hook:
```yml
on-run-end:
  - "grant select on all tables in schema  {{ target.schema }} to group reporting"
```

Code:
```sql
SELECT 
  grantee, privilege_type, table_name
FROM 
  information_schema.role_table_grants
WHERE table_name='fct_orders'
```
#### Output
| gitpod    | INSERT     | fct_orders |
|-----------|------------|------------|
| gitpod    | SELECT     | fct_orders |
| gitpod    | UPDATE     | fct_orders |
| gitpod    | DELETE     | fct_orders |
| gitpod    | TRUNCATE   | fct_orders |
| gitpod    | REFERENCES | fct_orders |
| gitpod    | TRIGGER    | fct_orders |
| reporting | SELECT     | fct_orders |
