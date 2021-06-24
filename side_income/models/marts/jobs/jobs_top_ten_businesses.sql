
with business_payouts as ( 
  select 
    business_service
  , round(
      (sum(std_earnings) + 
        sum(bonus_earnings) + 
        sum(tip_earnings) + 
        sum(other_earnings))/count(1)
      , 2)                                  as avg_restaurant_payout
  from 
    {{ ref('stg_job_payouts') }}
  where 1=1
    and job_title_id = 1                    -- doordash is job 1
  group by 
    business_service
  having 
    count(1) > 2                            -- keep if at least 3 deliveries from business
  order by 
    2 desc 
  limit 10
)

select 
  *
from 
  business_payouts
