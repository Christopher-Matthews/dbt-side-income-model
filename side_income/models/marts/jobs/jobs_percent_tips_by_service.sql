with job as (
  select 
    *
  from 
    {{ ref('stg_job_job') }}
),

earnings as (
  select 
    *
  from 
    {{ ref('stg_job_payouts') }} 
),

total_jobs_tipped as ( 
  select 
    job.service_title

    , sum(
        case 
          when (earnings.tip_earnings > 0) 
            then 1 
          else 0 
        end
        )                                             as tip_ct

    , avg(
        case 
          when (earnings.tip_earnings > 0) 
            then earnings.tip_earnings 
          else null 
        end
        )                                             as avg_tip_amount

  from
    earnings
  join 
    job on 1=1
      and earnings.job_title_id = job.job_title_id
  where 1=1
    and earnings.tip_earnings > 0
  group by 1
),

total_jobs_completed as (
  select 
    *
  from 
    {{ ref('jobs_completed_jobs_by_service_agg') }}
)

select 
    total_jobs_tipped.service_title
  , round(
      total_jobs_tipped.avg_tip_amount
      , 2
  )                                                   as avg_tip_amount
  , round( 
      total_jobs_tipped.tip_ct/total_jobs_completed.total_jobs_completed
      , 2
    )                                                 as percent_tippers
from 
  total_jobs_tipped 
join 
  total_jobs_completed on 1=1
    and total_jobs_tipped.service_title = total_jobs_completed.service_title

