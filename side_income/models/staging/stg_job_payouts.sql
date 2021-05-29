
with clean_payouts as (
  select 
      payoutID          as payout_id
    , jobID             as job_title_id
    , date              as completed_date
    , businessName      as business_service
    , basePay           as std_earnings
    , peakPayBonuses    as bonus_earnings
    , customerTip       as tip_earnings
    , otherPay          as other_earnings
    , incidentNote      as completion_notes
  from 
    {{source('app_stats', 'raw_payouts')}}
  where 
    payoutID is not null
)

select 
  *
from
  clean_payouts