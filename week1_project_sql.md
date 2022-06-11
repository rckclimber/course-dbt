## Question 1: How many users do we have?
_select count(distinct user_id) from dbt_gaurang_s.stg_greenery_users;_

## Question 2: On average, how many orders do we receive per hour?
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

## Q3: On average, how long does an order take from being placed to being delivered?

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

## Q4: How many users have only made one purchase? Two purchases? Three+ purchases?

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
;

## Q5: On average, how many unique sessions do we have per hour?

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