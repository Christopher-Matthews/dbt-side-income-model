with doordash_earning as (
  select 
      completed_date
    , total_earnings
  from 
    {{ ref('int_jobs_daily_earning_by_service') }}
  where 
    service_title = 'Doordash'
),

dates as (
  select
    *
  from 
    {{ ref('core_dim_date' ) }}
),

joined_earnings as (
  select 
    *
  from 
    dates 
  left join 
    doordash_earning on 
      dates.date_day = doordash_earning.completed_date
),

running_earning as ( 
select 
  *
  , coalesce(
      sum(total_earnings) 
        over (order by date_day), 0
    )                                                 as running_total_earnings
from 
  joined_earnings
)

select 
    date_day
  , day_of_week
  , 'Doordash'                                            as service_title
  , running_total_earnings
from 
  running_earning