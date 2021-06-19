with job_desc as (
  select 
    *
  from 
    --`bold-artifact-312304.dbt_chris.stg_job_business_stats`
    {{ ref('stg_job_business_stats') }}
),

payouts as (
  select 
    *
  from 
    --`bold-artifact-312304.dbt_chris.stg_job_payouts`
    {{ ref('stg_job_payouts') }}
),

service_provided as (
  select 
    *
  from 
    --`bold-artifact-312304.dbt_chris.stg_job_job`
    {{ ref('stg_job_job') }}
),

job_class_payouts as (
  select 
      payouts.completed_date
    , payouts.std_earnings +
        payouts.bonus_earnings +
        payouts.tip_earnings +
        payouts.other_earnings                                  as total_earnings
    , service_provided.service_title

    , case
      when (service_provided.service_title = 'Doordash') 
        then (
          case 
            when (job_desc.business_price_rating = '1')
              then '$'
            when (job_desc.business_price_rating = '2')
              then '$$'
            when (job_desc.business_price_rating = '3')
              then '$$$'
            else 'OTHER' 
            end 
            )
      when (service_provided.service_title = 'Lyft')
        then job_desc.business_name
      else 'error'
      end                                                       as job_class

  from 
    payouts 
  left join 
    job_desc on 1=1
      and payouts.business_service = job_desc.business_name
  inner join 
    service_provided on 1=1
      and payouts.job_title_id = service_provided.job_title_id
)

select 
  *
from 
  job_class_payouts
where 
  job_class != 'OTHER'
order by 
  completed_date