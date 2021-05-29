
with clean_mileage as (
  select 
      milesID         as mileage_id
    , jobID           as job_title_id
    , date            as mileage_date
    , milesDriven     as total_mileage
  from
    {{source('app_stats', 'raw_miles_driven')}}
  where 
    milesID is not null
)

select 
  *
from 
  clean_mileage