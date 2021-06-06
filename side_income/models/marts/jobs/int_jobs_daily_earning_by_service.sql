with payouts as (
    select 
        *
    from 
        {{ ref('stg_job_payouts') }}
),

job_titles as (
    select 
        *
    from 
        {{ ref('stg_job_job') }}
),

total_payouts_by_job as ( 
    select 
          payouts.completed_date
        , job_titles.service_title 
        , sum(payouts.std_earnings) as std_earnings
        , sum(payouts.bonus_earnings) as bonus_earnings
        , sum(payouts.tip_earnings) as tip_earnings
        , sum(payouts.other_earnings) as other_earnings
        , round( 
            (sum(payouts.std_earnings) +
                sum(payouts.bonus_earnings) +
                sum(payouts.tip_earnings) +
                sum(payouts.other_earnings))
            , 2
            ) as total_earnings
    from 
        payouts
    left join  
        job_titles on 
            payouts.job_title_id = job_titles.job_title_id

    group by 
        payouts.completed_date
        , job_titles.service_title
)

select 
    *
from 
    total_payouts_by_job
    