# week 2 Project Questions and Answers

## Q1: What is our user repeat rate??
####  Ans: **79.83%**

Code:
```sql
  with user_cohort as (
  select  
    sum(case when total_orders_lifetime >=2 then 1 else 0 end) as users_with_2_or_more_purchases
    , sum (case when total_orders_lifetime >=1 then 1 else 0 end) as users_who_purchased
  from dbt_gaurang_s.fct_usr_orders
),
final as (
select 
  (users_with_2_or_more_purchases::float / users_who_purchased::float)::float as repeat_rate
from user_cohort
)
select * from final
 
```

## Q2: What are good indicators of a user who will likely purchase again? <br/> What about indicators of users who are likely NOT to purchase again? <br/>If you had more data, what features would you want to look into to answer this question?
####  Ans: Some ideas I would like to explore: 
- if there is a relationship between promo code usage and the repeat purchase? do users who make first purchase using promo code, likely to purchase again?
- if there is a relation between order_total of the first order and the likelihood of the user purchase again
- if there is a relation between delayed_order_delivery than estimated_delivery, are users likely not to purchase if the delivery is delayed? 

## Marts models added: 
I added a total of 3 marts
1. Core:<br/> 
       Idea of the models in core mart is to get basic core business information at a glance.  Core mart has a 3 models, *dim_products*, *dim_users*, *fct_orders* 
        - *dim_products* has the product information in our store, current inventory, how many times products been ordered, total quantity ordered in lifetime
        - *dim_users* has the user information in our store, users address, email, phone number,  no. of orders in lifetime, total spends in user lifetime
        - *fct_orders* has all the order level information, along with actual time to delivery and difference between estimate and the actual delivery time  
2. Marketing: <br/>
      Idea of the models in marketing mart is to make information that a marketing department might need on a regular basis, Mainly, It contains the recency, frequency, monetary values for users, How recent was the last order, how frequently the user ordered, how much a user has spent. eg: if we want to target certain users whose days_since last order has passed a certain number etc. Marketing mart has 1 model so far *fct_usr_orders*
      - *fct_usr_orders* contains the order information the user level including total spends in a lifetime, total orderes in user lifetime, average spends per order, days since last order 

3. Product: <br/>
      Idea of the models in product mart is to make information readily available that a product team might be interested in. It contains information such has, length of session, no of events in a user session, whether session was abandoned or sucess (if the user placed an order) It has one model. *fct_page_views* 
      - *fct_page_views* contains session level details for all the sessions on our store 

### We added some more models and transformed some data! Now we need to make sure they’re accurately reflecting the data. Add dbt tests into your dbt project on your existing models from Week 1, and new models from the section above
#### What assumptions are you making about each model? (i.e. why are you adding each test?)
- Assumptions I'm making at this stage is that all id's are unique, in the staging models, there is no duplicate user_ids, order_ids, products_ids 

### Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
- I havent added any tests in the models yet, I hope to add that in this coming week

## Apply these changes to your github repo
## Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
- We can setup a notification email, whenever a tests fails on dbt run 