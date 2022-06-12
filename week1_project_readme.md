# week 1 Project Questions and Answers

## Q1: How many users do we have?
####  Ans: *130*

Code:
```sql
  select count(distinct user_id) from dbt_gaurang_s.stg_greenery_users;
```

## Q2: On average, how many orders do we receive per hour?
####  Ans: *15 orders per hour*

Code:
```sql
select
  round(avg (No_of_Orders))
from
  (
    select 
      count(order_id) as No_of_Orders, 
      date_trunc('hour', created_at::time) as hour_of_day
    from
      dbt_gaurang_s.stg_greenery_orders
    group by hour_of_day
    order by hour_of_day asc
  )x
;
```

## Q3: On average, how long does an order take from being placed to being delivered?
####  Ans: *On an average 4 days*

Code:
```sql
select
  round(avg (noofdays)) as avg_time_to_deliver
from
(
  select
    abs(extract(day from delivered_at::timestamp - created_at::timestamp)) as noofdays
  from
        dbt_gaurang_s.stg_greenery_orders
)x
;
```

## Q4: How many users have only made one purchase? Two purchases? Three+ purchases?
_Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase._
#### Ans: 
*Users_with_1_purchase 
  : 25 
Users_with_2_purchases
  : 28 
Users_with_3_or_more_purchases
  : 71*

Code:

```sql
With cte_user_totalorders (username, totalorders) 
as (
    select
        distinct x.user_name,
        count(x.order_id) over (partition by x.user_id) as no_of_orders
      from
      (
        dbt_gaurang_s.stg_greenery_orders o
        inner join  (select user_id as u_user_id, concat(first_name,' ', last_name) as user_name from dbt_gaurang_s.stg_greenery_users) u on u.u_user_id = o.user_id 
      )x
      
      order by no_of_orders desc
)

select
  sum(case when totalorders = 1 then 1 else 0 end) as users_with_1_purchases
  , sum(case when totalorders = 2 then 1 else 0 end) as users_with_2_purchases
  , sum(case when totalorders >= 3 then 1 else 0 end) as users_with_3_or_more_purchases
from cte_user_totalorders
```

## Q5: On average, how many unique sessions do we have per hour?
####  Ans: *39 unique sessions per hour*

Code:

```sql
select
  round(avg (No_of_sessions))
from
  (
    select 
      count(distinct session_id) as No_of_sessions, 
      date_trunc('hour', created_at::time) as hour_of_day
    from
      dbt_gaurang_s.stg_greenery_events
    group by hour_of_day
    order by hour_of_day
  )x
;
```
