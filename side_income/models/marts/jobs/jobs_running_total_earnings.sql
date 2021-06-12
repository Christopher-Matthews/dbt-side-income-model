with lyft_earning as (
  select
    *
  from 
    {{ ref('int_jobs_running_lyft_earnings') }}
),

doordash_earning as (
  select
    *
  from 
    {{ ref('int_jobs_running_doordash_earnings') }}
),

combined_earning as (
  select 
      lyft_earning.date_day
    , lyft_earning.day_of_week
    , lyft_earning.running_total_earnings + 
        doordash_earning.running_total_earnings           as running_total_earnings
  from 
    lyft_earning
  left join 
    doordash_earning on 
      lyft_earning.date_day = doordash_earning.date_day
)

select  
  *
from 
  combined_earning
