
with clean_job as (
  select 
      jobID       as job_title_id
    , jobName     as service_title
  from 
    {{source('app_stats', 'raw_job')}}
  where 
    jobID is not null
)

select 
  *
from 
  clean_job 
