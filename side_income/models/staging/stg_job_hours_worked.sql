
with clean_hours as (
  select
      hoursID                 as hours_worked_id
    , jobID                   as job_title_id
    , date                    as work_date
    , hours                   as hours_worked 
    , minutes                 as minutes_worked
    , round(
        (hours + minutes/60)
        , 4)                  as total_time_worked
  from 
    {{source('app_stats', 'raw_hours_worked')}}
  where 
    hoursID is not null
)

select 
  *
from 
  clean_hours