with total_earnings as (
  select
    sum(total_earnings)       as total_lifetime_earnings
  from 
    {{ ref('int_jobs_daily_earning_by_service') }}
)

select 
  *
from 
  total_earnings