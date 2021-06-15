with earnings as (
  select 
      completed_date
    , service_title
    , total_earnings
  from 
    {{ ref('int_jobs_daily_earning_by_service') }}
),

hours_worked as (
  select 
      work_date
    , total_time_worked
  from 
    {{ ref('stg_job_hours_worked') }}
),

miles as (
  select  
      mileage_date
    , sum(total_mileage)                                      as total_mileage
  from 
    {{ ref('stg_job_mileage') }}
  group by 
    1
)

select 
    earnings.completed_date
  , earnings.service_title
  , round(
      earnings.total_earnings/hours_worked.total_time_worked
      , 2
    )                                                         as dollars_per_hour
  , round(
      earnings.total_earnings/miles.total_mileage 
      , 2
    )                                                         as dollars_per_mile
from 
  earnings 
left join 
  hours_worked on 1=1
    and earnings.completed_date = hours_worked.work_date
left join 
  miles on 1=1
    and earnings.completed_date = miles.mileage_date
order by 
  earnings.completed_date

