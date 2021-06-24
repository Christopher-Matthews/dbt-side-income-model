
with top_3_businesses as ( 
  select 
      row_number() over (
        order by avg_restaurant_payout desc
        )                                                     as business_rank
    , business_service
  from 
    {{ ref('jobs_top_ten_businesses') }}
  order by 
    avg_restaurant_payout desc 
  limit 2
),

business_stats as (
  select 
    *
  from 
    {{ ref('stg_job_business_stats') }}
),

final as ( 
  select 
      top_3_businesses.*
    , business_stats.business_food_type
    , business_stats.business_star_rating
    , business_stats.num_business_rating
    , case 
        when(business_stats.business_price_rating = '1')
            then '$'
        when(business_stats.business_price_rating = '2')
            then '$$'
        when(business_stats.business_price_rating = '3')
            then '$$$'
        else 'NO RATING FOUND'
        end as restaurant_price_rating
  from 
    top_3_businesses
    join business_stats on 1=1
        and top_3_businesses.business_service = business_stats.business_name
)

select 
    *
from 
    final