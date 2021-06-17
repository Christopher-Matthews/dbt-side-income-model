with daily_jobs as (
  select 
      service_title
    , sum(total_jobs_completed)     as total_jobs_completed 
  from 
    {{ ref('int_jobs_daily_earning_by_service') }}
  group by 
    service_title
)

select
  *
from 
  daily_jobs

